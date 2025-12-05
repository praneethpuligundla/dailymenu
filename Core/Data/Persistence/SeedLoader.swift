import Foundation
import CoreData
import OSLog

/// Loads seed activities from bundled JSON into Core Data store
@MainActor
final class SeedLoader {
    private let log = Logger(subsystem: "com.dailymenu.app", category: "seed")
    private let store: Store
    private let userDefaults: UserDefaults

    private static let seedLoadedKey = "com.dailymenu.seedLoaded"

    init(store: Store, userDefaults: UserDefaults = .standard) {
        self.store = store
        self.userDefaults = userDefaults
    }

    /// Load seed data if not already loaded (idempotent)
    func loadSeedIfNeeded() {
        // Check if already loaded
        if userDefaults.bool(forKey: Self.seedLoadedKey) {
            log.info("Seed data already loaded, skipping")
            return
        }

        log.info("Loading seed data for first time")

        // Begin performance monitoring
        let signpostID = PerformanceMonitor.shared.beginSeedLoad()

        do {
            try loadSeed()
            userDefaults.set(true, forKey: Self.seedLoadedKey)
            log.info("Seed data loaded successfully")
            PerformanceMonitor.shared.endSeedLoad(signpostID: signpostID, count: 110)
        } catch {
            log.error("Failed to load seed data: \(error)")
            PerformanceMonitor.shared.endSeedLoad(signpostID: signpostID, count: 0)
            // Don't mark as loaded if it failed
        }
    }

    private func loadSeed() throws {
        // Load from split seed files by time category
        let seedFiles = ["activities_5min", "activities_15min", "activities_30plus"]
        var allActivities: [SeedActivity] = []

        for seedFile in seedFiles {
            if let url = Bundle.main.url(forResource: seedFile, withExtension: "json") {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let activities = try decoder.decode([SeedActivity].self, from: data)
                allActivities.append(contentsOf: activities)
                log.info("Loaded \(activities.count) activities from \(seedFile).json")
            } else {
                log.warning("Seed file \(seedFile).json not found, skipping")
            }
        }

        // Fallback to legacy single file if split files not found
        if allActivities.isEmpty {
            guard let url = Bundle.main.url(forResource: "activities", withExtension: "json") else {
                log.error("No seed JSON files found in bundle")
                throw SeedError.fileNotFound
            }
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allActivities = try decoder.decode([SeedActivity].self, from: data)
        }

        let activities = allActivities
        log.info("Parsed \(activities.count) total activities from seed JSON files")

        // Insert into Core Data
        let context = store.viewContext

        for activity in activities {
            // Check for duplicates by ID
            let fetchRequest = ActivityEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", activity.id as CVarArg)
            fetchRequest.fetchLimit = 1

            let existing = try context.fetch(fetchRequest)
            if !existing.isEmpty {
                log.debug("Skipping duplicate activity: \(activity.id)")
                continue
            }

            // Create new entity
            let entity = ActivityEntity(context: context)
            entity.id = activity.id
            entity.title = activity.title
            entity.descriptionText = activity.description
            entity.expectedMinutes = Int16(activity.expectedMinutes)
            entity.category = activity.category
            entity.energy = activity.energy
            entity.context = activity.context
            entity.repeatable = activity.repeatable
            entity.source = "seed"
            entity.moderationStatus = "approved"

            // Store tags as JSON array string
            if let tagsData = try? JSONEncoder().encode(activity.tags),
               let tagsString = String(data: tagsData, encoding: .utf8) {
                entity.tagsJSON = tagsString
            }
        }

        // Save all at once
        store.save()
        log.info("Saved \(activities.count) seed activities to Core Data")
    }

    /// Force reload seed data (useful for development/testing)
    func forceReload() {
        log.warning("Force reloading seed data")
        userDefaults.set(false, forKey: Self.seedLoadedKey)
        loadSeedIfNeeded()
    }
}

// MARK: - Seed Activity Model

private struct SeedActivity: Codable {
    let id: UUID
    let title: String
    let description: String
    let expectedMinutes: Int
    let category: String
    let energy: String
    let context: String
    let repeatable: Bool
    let tags: [String]

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        // Parse "id" as string and generate deterministic UUID from it
        let idString = try container.decode(String.self, forKey: .id)
        // Create deterministic UUID using namespace + string ID
        self.id = Self.deterministicUUID(from: idString)

        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        expectedMinutes = try container.decode(Int.self, forKey: .expectedMinutes)
        category = try container.decode(String.self, forKey: .category)
        energy = try container.decode(String.self, forKey: .energy)
        context = try container.decode(String.self, forKey: .context)
        repeatable = try container.decode(Bool.self, forKey: .repeatable)
        tags = try container.decode([String].self, forKey: .tags)
    }

    /// Generate a deterministic UUID from a string identifier
    private static func deterministicUUID(from string: String) -> UUID {
        // Use a fixed namespace UUID for DailyMenu seed activities
        let namespace = UUID(uuidString: "A5B2C3D4-E5F6-4A5B-9C8D-7E6F5A4B3C2D")!

        // Create deterministic UUID using SHA1 hash of namespace + string
        var data = Data()
        data.append(contentsOf: namespace.uuidString.utf8)
        data.append(contentsOf: string.utf8)

        // Use hash to create UUID (first 16 bytes)
        let hash = data.withUnsafeBytes { buffer -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: 16)
            let bytes = buffer.bindMemory(to: UInt8.self)
            for (index, byte) in bytes.enumerated() {
                hash[index % 16] ^= byte
            }
            return hash
        }

        // Format as UUID string
        let uuidString = String(format: "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
                                hash[0], hash[1], hash[2], hash[3],
                                hash[4], hash[5],
                                hash[6], hash[7],
                                hash[8], hash[9],
                                hash[10], hash[11], hash[12], hash[13], hash[14], hash[15])

        return UUID(uuidString: uuidString) ?? UUID()
    }

    private enum CodingKeys: String, CodingKey {
        case id, title, description, expectedMinutes, category, energy, context, repeatable, tags
    }
}

// MARK: - Errors

enum SeedError: Error {
    case fileNotFound
    case invalidData
}
