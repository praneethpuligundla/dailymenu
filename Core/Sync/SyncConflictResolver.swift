import Foundation
import CoreData
import OSLog

/// Sync conflict resolver with local-wins-unless-newer-server policy
@MainActor
final class SyncConflictResolver {
    private let store: Store
    private let log = Logger(subsystem: "com.dailymenu.app", category: "sync")

    init(store: Store = .shared) {
        self.store = store
    }

    // MARK: - Merge Operations

    /// Merge remote favorites with local, preserving local data and resolving conflicts
    func mergeFavorites(remote: [RemoteFavorite]) -> MergeResult<FavoriteEntity> {
        var created = 0
        var updated = 0
        var conflicts = 0

        let localFavorites = store.fetchFavorites()
        let localById = Dictionary(uniqueKeysWithValues: localFavorites.map { ($0.id!, $0) })

        for remoteFavorite in remote {
            if let local = localById[remoteFavorite.id] {
                // Conflict resolution: local wins unless server is newer
                if let remoteTimestamp = remoteFavorite.updatedAt,
                   let localTimestamp = local.updatedAt,
                   remoteTimestamp > localTimestamp {
                    // Server is newer, update local
                    local.updatedAt = remoteTimestamp
                    updated += 1
                    log.info("Updated favorite \(remoteFavorite.id) from server (newer timestamp)")
                } else {
                    // Local wins or equal timestamps
                    conflicts += 1
                    log.info("Kept local favorite \(remoteFavorite.id) (local wins)")
                }
            } else {
                // New remote record, create locally
                let favorite = FavoriteEntity(context: store.viewContext)
                favorite.id = remoteFavorite.id
                if let activity = fetchActivity(by: remoteFavorite.activityId) {
                    favorite.activity = activity
                    favorite.createdAt = remoteFavorite.createdAt
                    favorite.updatedAt = remoteFavorite.updatedAt
                    created += 1
                    log.info("Created favorite \(remoteFavorite.id) from server")
                }
            }
        }

        store.save()
        return MergeResult(created: created, updated: updated, conflicts: conflicts)
    }

    /// Merge remote history entries with local, preserving local data
    func mergeHistoryEntries(remote: [RemoteHistoryEntry]) -> MergeResult<HistoryEntryEntity> {
        var created = 0
        var updated = 0
        var conflicts = 0

        let localEntries = store.fetchHistoryEntries()
        let localById = Dictionary(uniqueKeysWithValues: localEntries.map { ($0.id!, $0) })

        for remoteEntry in remote {
            if let local = localById[remoteEntry.id] {
                // Conflict resolution: local wins unless server is newer
                if let remoteTimestamp = remoteEntry.updatedAt,
                   let localTimestamp = local.updatedAt,
                   remoteTimestamp > localTimestamp {
                    // Server is newer, update local
                    local.updatedAt = remoteTimestamp
                    updated += 1
                    log.info("Updated history entry \(remoteEntry.id) from server (newer timestamp)")
                } else {
                    // Local wins or equal timestamps
                    conflicts += 1
                    log.info("Kept local history entry \(remoteEntry.id) (local wins)")
                }
            } else {
                // New remote record, create locally
                let entry = HistoryEntryEntity(context: store.viewContext)
                entry.id = remoteEntry.id
                if let activity = fetchActivity(by: remoteEntry.activityId) {
                    entry.activity = activity
                    entry.completedAt = remoteEntry.completedAt
                    entry.updatedAt = remoteEntry.updatedAt
                    created += 1
                    log.info("Created history entry \(remoteEntry.id) from server")
                }
            }
        }

        store.save()
        return MergeResult(created: created, updated: updated, conflicts: conflicts)
    }

    /// Merge remote hidden activities with local preferences
    func mergeHiddenActivities(remote: [UUID]) -> MergeResult<UserPrefsEntity> {
        var created = 0
        var updated = 0

        let prefs = store.fetchOrCreateUserPrefs()

        // Parse current hidden activities
        var currentHidden = Set<UUID>()
        if let excludedJSON = prefs.excludedCategories,
           let data = excludedJSON.data(using: .utf8),
           let hidden = try? JSONDecoder().decode([UUID].self, from: data) {
            currentHidden = Set(hidden)
        }

        // Merge with remote (union)
        let mergedHidden = currentHidden.union(Set(remote))

        if mergedHidden.count > currentHidden.count {
            // New hidden activities from server
            if let encoded = try? JSONEncoder().encode(Array(mergedHidden)),
               let json = String(data: encoded, encoding: .utf8) {
                prefs.excludedCategories = json
                prefs.updatedAt = Date()
                updated += 1
                log.info("Merged hidden activities (added \(mergedHidden.count - currentHidden.count) from server)")
            }
        }

        store.save()
        return MergeResult(created: created, updated: updated, conflicts: 0)
    }

    // MARK: - Helper Methods

    private func fetchActivity(by id: UUID) -> ActivityEntity? {
        let activities = store.fetchActivities(predicate: NSPredicate(format: "id == %@", id as CVarArg))
        return activities.first
    }
}

// MARK: - Remote Models

struct RemoteFavorite: Codable {
    let id: UUID
    let activityId: UUID
    let createdAt: Date
    let updatedAt: Date?
    let etag: String?
}

struct RemoteHistoryEntry: Codable {
    let id: UUID
    let activityId: UUID
    let completedAt: Date
    let updatedAt: Date?
    let etag: String?
}

// MARK: - Merge Result

struct MergeResult<T> {
    let created: Int
    let updated: Int
    let conflicts: Int

    var total: Int { created + updated }
    var hasConflicts: Bool { conflicts > 0 }

    var summary: String {
        var parts: [String] = []
        if created > 0 { parts.append("\(created) created") }
        if updated > 0 { parts.append("\(updated) updated") }
        if conflicts > 0 { parts.append("\(conflicts) conflicts (local kept)") }
        return parts.isEmpty ? "No changes" : parts.joined(separator: ", ")
    }
}
