import XCTest
import CoreData
@testable import DailyMenu

/// Smoke tests for seeded activity library
@MainActor
final class SeedLoaderTests: XCTestCase {
    var store: Store!
    var seedLoader: SeedLoader!
    var testDefaults: UserDefaults!

    override func setUp() async throws {
        try await super.setUp()

        // Create in-memory store for testing
        store = createInMemoryStore()

        // Use test user defaults to avoid polluting real defaults
        testDefaults = UserDefaults(suiteName: "com.dailymenu.test")!
        testDefaults.removePersistentDomain(forName: "com.dailymenu.test")

        seedLoader = SeedLoader(store: store, userDefaults: testDefaults)
    }

    override func tearDown() async throws {
        store = nil
        seedLoader = nil
        testDefaults?.removePersistentDomain(forName: "com.dailymenu.test")
        testDefaults = nil
        try await super.tearDown()
    }

    // MARK: - Test Helpers

    private func createInMemoryStore() -> Store {
        let container = NSPersistentContainer(name: "DailyMenu")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Failed to load in-memory store: \(error?.localizedDescription ?? "unknown")")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        return Store(container: container)
    }

    // MARK: - AC1: Seed JSON parsed and stored with tags

    func testSeedLoadParsesAndStoresActivities() throws {
        // When
        seedLoader.loadSeedIfNeeded()

        // Then
        let activities = store.fetchActivities()
        XCTAssertGreaterThan(activities.count, 0, "Should have loaded activities from seed")
        XCTAssertGreaterThanOrEqual(activities.count, 100, "Should have at least 100 activities")

        // Verify tags are present
        let activitiesWithTags = activities.filter { !($0.tagsJSON?.isEmpty ?? true) }
        XCTAssertGreaterThan(activitiesWithTags.count, 0, "Should have activities with tags")

        // Verify required fields are populated
        for activity in activities.prefix(10) {
            XCTAssertNotNil(activity.id)
            XCTAssertFalse(activity.title?.isEmpty ?? true)
            XCTAssertFalse(activity.descriptionText?.isEmpty ?? true)
            XCTAssertGreaterThan(activity.expectedMinutes, 0)
            XCTAssertFalse(activity.category?.isEmpty ?? true)
            XCTAssertFalse(activity.energy?.isEmpty ?? true)
            XCTAssertFalse(activity.context?.isEmpty ?? true)
        }
    }

    // MARK: - AC2: Categories cover all required types

    func testSeedCoversAllCategories() throws {
        // When
        seedLoader.loadSeedIfNeeded()

        // Then
        let activities = store.fetchActivities()

        let categories = Set(activities.map { $0.category })
        XCTAssertTrue(categories.contains("starter"), "Should have Starter activities")
        XCTAssertTrue(categories.contains("main"), "Should have Main activities")
        XCTAssertTrue(categories.contains("dessert"), "Should have Dessert activities")
        XCTAssertTrue(categories.contains("connection"), "Should have Connection activities")
        XCTAssertTrue(categories.contains("lowBattery"), "Should have Low-Battery activities")

        // Verify each category has sufficient activities
        let starters = activities.filter { $0.category == "starter" }
        let mains = activities.filter { $0.category == "main" }
        let desserts = activities.filter { $0.category == "dessert" }
        let connections = activities.filter { $0.category == "connection" }
        let lowBattery = activities.filter { $0.category == "lowBattery" }

        XCTAssertGreaterThan(starters.count, 0, "Should have Starter activities")
        XCTAssertGreaterThan(mains.count, 0, "Should have Main activities")
        XCTAssertGreaterThan(desserts.count, 0, "Should have Dessert activities")
        XCTAssertGreaterThan(connections.count, 0, "Should have Connection activities")
        XCTAssertGreaterThan(lowBattery.count, 0, "Should have Low-Battery activities")
    }

    // MARK: - AC3: Smoke test can query 3 random activities with tags

    func testCanQueryThreeRandomActivitiesWithTags() throws {
        // Given
        seedLoader.loadSeedIfNeeded()

        // When - Query 3 random activities
        let allActivities = store.fetchActivities()
        guard allActivities.count >= 3 else {
            XCTFail("Not enough activities loaded")
            return
        }

        let randomActivities = Array(allActivities.shuffled().prefix(3))

        // Then - Verify each has tags
        XCTAssertEqual(randomActivities.count, 3, "Should have queried 3 activities")

        for activity in randomActivities {
            XCTAssertNotNil(activity.tagsJSON, "Activity should have tags JSON")
            XCTAssertFalse(activity.tagsJSON?.isEmpty ?? true, "Tags JSON should not be empty")

            // Parse tags JSON to verify it's valid
            if let tagsJSON = activity.tagsJSON,
               let data = tagsJSON.data(using: .utf8),
               let tags = try? JSONDecoder().decode([String].self, from: data) {
                XCTAssertGreaterThan(tags.count, 0, "Should have at least one tag")
            } else {
                XCTFail("Failed to parse tags JSON for activity: \(activity.title ?? "unknown")")
            }

            // Verify other required fields
            XCTAssertNotNil(activity.id)
            XCTAssertFalse(activity.title?.isEmpty ?? true)
            XCTAssertFalse(activity.category?.isEmpty ?? true)
            XCTAssertFalse(activity.energy?.isEmpty ?? true)
            XCTAssertFalse(activity.context?.isEmpty ?? true)
        }
    }

    // MARK: - Idempotency Tests

    func testLoadSeedIsIdempotent() throws {
        // Given - First load
        seedLoader.loadSeedIfNeeded()
        let firstCount = store.fetchActivities().count

        // When - Second load
        seedLoader.loadSeedIfNeeded()
        let secondCount = store.fetchActivities().count

        // Then - Should not duplicate
        XCTAssertEqual(firstCount, secondCount, "Seed load should be idempotent")
    }

    func testForceReloadReplacesData() throws {
        // Given
        seedLoader.loadSeedIfNeeded()
        let firstCount = store.fetchActivities().count
        XCTAssertGreaterThan(firstCount, 0)

        // When - Clear and force reload
        // Delete all activities
        let activities = store.fetchActivities()
        for activity in activities {
            store.viewContext.delete(activity)
        }
        store.save()

        // Force reload
        seedLoader.forceReload()

        // Then
        let newCount = store.fetchActivities().count
        XCTAssertEqual(newCount, firstCount, "Force reload should restore all activities")
    }

    // MARK: - Tag Coverage Tests

    func testActivitiesHaveRequiredTags() throws {
        // Given
        seedLoader.loadSeedIfNeeded()

        // When
        let activities = store.fetchActivities()

        // Then - Verify tag presence and variety
        var allTags: Set<String> = []
        for activity in activities {
            if let tagsJSON = activity.tagsJSON,
               let data = tagsJSON.data(using: .utf8),
               let tags = try? JSONDecoder().decode([String].self, from: data) {
                allTags.formUnion(tags)
            }
        }

        // Should have diverse tags
        XCTAssertGreaterThan(allTags.count, 10, "Should have diverse tag set")
    }

    // MARK: - Energy and Context Coverage

    func testActivitiesHaveEnergyAndContextVariety() throws {
        // Given
        seedLoader.loadSeedIfNeeded()

        // When
        let activities = store.fetchActivities()

        // Then
        let energyLevels = Set(activities.map { $0.energy })
        let contexts = Set(activities.map { $0.context })

        XCTAssertTrue(energyLevels.contains("low"), "Should have low energy activities")
        XCTAssertTrue(energyLevels.contains("okay"), "Should have okay energy activities")
        XCTAssertTrue(energyLevels.contains("upForSomething"), "Should have upForSomething energy activities")

        XCTAssertTrue(contexts.contains("solo"), "Should have solo activities")
        XCTAssertTrue(contexts.contains("withSomeone"), "Should have withSomeone activities")
    }

    // MARK: - Source and Moderation

    func testAllSeedActivitiesAreApproved() throws {
        // Given
        seedLoader.loadSeedIfNeeded()

        // When
        let activities = store.fetchActivities()

        // Then
        for activity in activities {
            XCTAssertEqual(activity.source, "seed", "Should be marked as seed source")
            XCTAssertEqual(activity.moderationStatus, "approved", "Should be approved")
        }
    }
}
