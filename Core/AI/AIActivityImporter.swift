import Foundation
import CoreData

/// Imports AI-generated activities from Share Extension into Core Data
@MainActor
final class AIActivityImporter: ObservableObject {

    @Published var pendingCount: Int = 0
    @Published var communityQueueCount: Int = 0

    private let store: Store

    init(store: Store = .shared) {
        self.store = store
        refreshCounts()
    }

    /// Check and import any pending activities from Share Extension
    func importPendingActivities() -> Int {
        let pending = SharedActivityStorage.getPendingActivities()
        guard !pending.isEmpty else { return 0 }

        var imported = 0
        let context = store.viewContext

        for activity in pending {
            // Check for duplicates by title
            let fetchRequest = ActivityEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", activity.title)
            fetchRequest.fetchLimit = 1

            do {
                let existing = try context.fetch(fetchRequest)
                if !existing.isEmpty {
                    continue // Skip duplicates
                }
            } catch {
                continue
            }

            // Create new activity entity
            let entity = ActivityEntity(context: context)
            entity.id = UUID()
            entity.title = activity.title
            entity.descriptionText = activity.description
            entity.expectedMinutes = Int16(activity.expectedMinutes)
            entity.energy = activity.energy
            entity.context = activity.context
            entity.category = activity.category
            entity.source = "ai-import"
            entity.moderationStatus = "approved"
            entity.repeatable = true

            // Store tags as JSON
            if let tagsData = try? JSONEncoder().encode(activity.tags),
               let tagsString = String(data: tagsData, encoding: .utf8) {
                entity.tagsJSON = tagsString
            }

            imported += 1
        }

        if imported > 0 {
            store.save()
        }

        // Clear pending after import
        SharedActivityStorage.clearPendingActivities()
        refreshCounts()

        return imported
    }

    /// Submit queued activities to community server
    func submitToCommunity() async -> Result<Int, CommunitySubmissionError> {
        let queue = SharedActivityStorage.getCommunityQueue()
        guard !queue.isEmpty else {
            return .success(0)
        }

        // For now, just store locally with a "pending_community" flag
        // In production, this would POST to your server
        do {
            let submissions = try await submitToServer(queue)
            SharedActivityStorage.clearCommunityQueue()
            refreshCounts()
            return .success(submissions)
        } catch {
            return .failure(.networkError(error))
        }
    }

    /// Placeholder for server submission
    private func submitToServer(_ activities: [AIActivityParser.ParsedActivity]) async throws -> Int {
        // TODO: Implement actual server submission
        // For now, simulate success and store locally

        // Store submission intent in UserDefaults for later sync
        var submissions = getCommunitySubmissions()
        submissions.append(contentsOf: activities)

        if let data = try? JSONEncoder().encode(submissions) {
            UserDefaults.standard.set(data, forKey: "community_submissions_pending")
        }

        return activities.count
    }

    /// Get locally stored community submissions
    func getCommunitySubmissions() -> [AIActivityParser.ParsedActivity] {
        guard let data = UserDefaults.standard.data(forKey: "community_submissions_pending"),
              let submissions = try? JSONDecoder().decode([AIActivityParser.ParsedActivity].self, from: data) else {
            return []
        }
        return submissions
    }

    /// Clear local community submissions
    func clearCommunitySubmissions() {
        UserDefaults.standard.removeObject(forKey: "community_submissions_pending")
    }

    /// Refresh pending counts
    func refreshCounts() {
        pendingCount = SharedActivityStorage.getPendingActivities().count
        communityQueueCount = SharedActivityStorage.getCommunityQueue().count
    }

    /// Export all user activities for community sharing
    func exportActivitiesForSharing() -> Data? {
        let fetchRequest = ActivityEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "source == %@", "ai-import")

        do {
            let activities = try store.viewContext.fetch(fetchRequest)
            let exportData = activities.compactMap { entity -> AIActivityParser.ParsedActivity? in
                guard let title = entity.title,
                      let desc = entity.descriptionText else { return nil }

                var tags: [String] = []
                if let tagsJSON = entity.tagsJSON,
                   let data = tagsJSON.data(using: .utf8),
                   let decoded = try? JSONDecoder().decode([String].self, from: data) {
                    tags = decoded
                }

                return AIActivityParser.ParsedActivity(
                    title: title,
                    description: desc,
                    expectedMinutes: Int(entity.expectedMinutes),
                    energy: entity.energy ?? "okay",
                    context: entity.context ?? "solo",
                    category: entity.category ?? "main",
                    tags: tags
                )
            }

            return try JSONEncoder().encode(exportData)
        } catch {
            return nil
        }
    }
}

// MARK: - Errors

enum CommunitySubmissionError: Error {
    case networkError(Error)
    case serverError(String)
    case notAuthenticated
}
