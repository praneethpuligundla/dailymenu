import XCTest
import CoreData
@testable import DailyMenu

/// Unit tests for Core Data Store - proves create, read, write operations
@MainActor
final class StoreTests: XCTestCase {
    var store: Store!
    var context: NSManagedObjectContext!

    override func setUp() async throws {
        try await super.setUp()

        // Create in-memory store for testing
        store = createInMemoryStore()
        context = store.viewContext
    }

    override func tearDown() async throws {
        store = nil
        context = nil
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

    // MARK: - Activity Entity Tests

    func testCreateActivity() {
        // Given
        let activity = ActivityEntity(context: context)
        let id = UUID()

        // When
        activity.id = id
        activity.title = "Morning Stretch"
        activity.descriptionText = "5-minute gentle stretching routine"
        activity.expectedMinutes = 5
        activity.category = "starter"
        activity.energy = "low"
        activity.context = "solo"
        activity.repeatable = true
        activity.source = "seed"
        activity.moderationStatus = "approved"
        activity.tagsJSON = "[\"morning\",\"wellness\"]"

        // Then
        XCTAssertNotNil(activity)
        XCTAssertEqual(activity.id, id)
        XCTAssertEqual(activity.title, "Morning Stretch")
        XCTAssertEqual(activity.expectedMinutes, 5)
        XCTAssertEqual(activity.category, "starter")
        XCTAssertEqual(activity.energy, "low")
    }

    func testSaveAndReadActivity() {
        // Given
        let activity = ActivityEntity(context: context)
        activity.id = UUID()
        activity.title = "Read a chapter"
        activity.descriptionText = "Pick up that book and enjoy a chapter"
        activity.expectedMinutes = 15
        activity.category = "main"
        activity.energy = "okay"
        activity.context = "solo"
        activity.repeatable = true
        activity.source = "seed"

        // When - Save
        store.save()

        // Then - Read
        let fetchedActivities = store.fetchActivities()
        XCTAssertEqual(fetchedActivities.count, 1)
        XCTAssertEqual(fetchedActivities.first?.title, "Read a chapter")
        XCTAssertEqual(fetchedActivities.first?.expectedMinutes, 15)
    }

    func testFetchActivitiesWithPredicate() {
        // Given
        let activity1 = ActivityEntity(context: context)
        activity1.id = UUID()
        activity1.title = "Quick walk"
        activity1.category = "starter"
        activity1.energy = "low"
        activity1.context = "solo"
        activity1.descriptionText = "5-min walk"
        activity1.expectedMinutes = 5
        activity1.repeatable = true
        activity1.source = "seed"

        let activity2 = ActivityEntity(context: context)
        activity2.id = UUID()
        activity2.title = "Cook a meal"
        activity2.category = "main"
        activity2.energy = "upForSomething"
        activity2.context = "solo"
        activity2.descriptionText = "Try a new recipe"
        activity2.expectedMinutes = 30
        activity2.repeatable = true
        activity2.source = "seed"

        store.save()

        // When
        let predicate = NSPredicate(format: "category == %@", "starter")
        let starters = store.fetchActivities(predicate: predicate)

        // Then
        XCTAssertEqual(starters.count, 1)
        XCTAssertEqual(starters.first?.title, "Quick walk")
    }

    // MARK: - Favorite Entity Tests

    func testCreateAndSaveFavorite() {
        // Given
        let activity = ActivityEntity(context: context)
        activity.id = UUID()
        activity.title = "Favorite Activity"
        activity.category = "main"
        activity.energy = "okay"
        activity.context = "solo"
        activity.descriptionText = "Test"
        activity.expectedMinutes = 10
        activity.repeatable = true
        activity.source = "seed"

        let favorite = FavoriteEntity(context: context)
        favorite.id = UUID()
        favorite.activity = activity
        favorite.createdAt = Date()

        // When
        store.save()

        // Then
        let favorites = store.fetchFavorites()
        XCTAssertEqual(favorites.count, 1)
        XCTAssertEqual(favorites.first?.activity?.title, "Favorite Activity")
        XCTAssertNotNil(favorites.first?.createdAt)
    }

    func testFavoriteActivityRelationship() {
        // Given
        let activity = ActivityEntity(context: context)
        activity.id = UUID()
        activity.title = "Relationship Test"
        activity.category = "main"
        activity.energy = "okay"
        activity.context = "solo"
        activity.descriptionText = "Test relationship"
        activity.expectedMinutes = 10
        activity.repeatable = true
        activity.source = "seed"

        let favorite = FavoriteEntity(context: context)
        favorite.id = UUID()
        favorite.activity = activity
        favorite.createdAt = Date()

        store.save()

        // When
        let fetchedActivity = store.fetchActivities().first
        let relatedFavorites = fetchedActivity?.favorites as? Set<FavoriteEntity>

        // Then
        XCTAssertNotNil(relatedFavorites)
        XCTAssertEqual(relatedFavorites?.count, 1)
        XCTAssertEqual(relatedFavorites?.first?.activity?.title, "Relationship Test")
    }

    // MARK: - HistoryEntry Entity Tests

    func testCreateAndSaveHistoryEntry() {
        // Given
        let activity = ActivityEntity(context: context)
        activity.id = UUID()
        activity.title = "Completed Activity"
        activity.category = "main"
        activity.energy = "okay"
        activity.context = "solo"
        activity.descriptionText = "Done!"
        activity.expectedMinutes = 10
        activity.repeatable = true
        activity.source = "seed"

        let entry = HistoryEntryEntity(context: context)
        entry.id = UUID()
        entry.activity = activity
        entry.completedAt = Date()
        entry.contextSnapshot = "{\"energy\":\"okay\",\"time\":\"morning\"}"

        // When
        store.save()

        // Then
        let entries = store.fetchHistoryEntries()
        XCTAssertEqual(entries.count, 1)
        XCTAssertEqual(entries.first?.activity?.title, "Completed Activity")
        XCTAssertNotNil(entries.first?.completedAt)
        XCTAssertNotNil(entries.first?.contextSnapshot)
    }

    // MARK: - UserPrefs Entity Tests

    func testFetchOrCreateUserPrefs() {
        // When - First fetch (should create)
        let prefs = store.fetchOrCreateUserPrefs()

        // Then
        XCTAssertNotNil(prefs)
        XCTAssertNotNil(prefs.id)

        // When - Second fetch (should return existing)
        let prefs2 = store.fetchOrCreateUserPrefs()

        // Then
        XCTAssertEqual(prefs.id, prefs2.id, "Should return same prefs object")
    }

    func testSaveUserPrefs() {
        // Given
        let prefs = store.fetchOrCreateUserPrefs()
        prefs.timeOptions = "[\"5-10\",\"15-30\",\"30+\"]"
        prefs.energyDefaults = "{\"default\":\"okay\"}"
        prefs.contextDefaults = "{\"default\":\"solo\"}"
        prefs.flagsJSON = "{\"cloudLLM\":false,\"sync\":false}"

        // When
        store.save()

        // Then
        let fetchedPrefs = store.fetchUserPrefs()
        XCTAssertNotNil(fetchedPrefs)
        XCTAssertEqual(fetchedPrefs?.timeOptions, "[\"5-10\",\"15-30\",\"30+\"]")
        XCTAssertEqual(fetchedPrefs?.flagsJSON, "{\"cloudLLM\":false,\"sync\":false}")
    }

    // MARK: - Tag Entity Tests

    func testCreateTag() {
        // Given
        let tag = TagEntity(context: context)
        tag.id = UUID()
        tag.name = "morning"

        // When
        store.save()

        // Then
        let request = TagEntity.fetchRequest()
        let tags = try? context.fetch(request)
        XCTAssertEqual(tags?.count, 1)
        XCTAssertEqual(tags?.first?.name, "morning")
    }

    // MARK: - Submission Entity Tests

    func testCreateSubmission() {
        // Given
        let submission = SubmissionEntity(context: context)
        submission.id = UUID()
        submission.payload = "{\"title\":\"User idea\",\"description\":\"Cool activity\"}"
        submission.status = "pending"
        submission.createdAt = Date()

        // When
        store.save()

        // Then
        let request = SubmissionEntity.fetchRequest()
        let submissions = try? context.fetch(request)
        XCTAssertEqual(submissions?.count, 1)
        XCTAssertEqual(submissions?.first?.status, "pending")
    }

    // MARK: - Background Save Tests

    func testBackgroundSave() async throws {
        // Given
        let backgroundContext = store.newBackgroundContext()

        // When
        await backgroundContext.perform {
            let activity = ActivityEntity(context: backgroundContext)
            activity.id = UUID()
            activity.title = "Background Activity"
            activity.category = "main"
            activity.energy = "okay"
            activity.context = "solo"
            activity.descriptionText = "Created in background"
            activity.expectedMinutes = 10
            activity.repeatable = true
            activity.source = "seed"
        }

        try await store.saveBackground(backgroundContext)

        // Then - Should merge to view context
        let activities = store.fetchActivities()
        XCTAssertEqual(activities.count, 1)
        XCTAssertEqual(activities.first?.title, "Background Activity")
    }

    // MARK: - Store Validation

    func testStoreInitialization() {
        // Then
        XCTAssertNotNil(store)
        XCTAssertNotNil(store.container)
        XCTAssertNotNil(store.viewContext)
    }

    func testViewContextConfiguration() {
        // Then
        XCTAssertTrue(context.automaticallyMergesChangesFromParent)
        XCTAssertTrue((context.mergePolicy as AnyObject) === (NSMergeByPropertyObjectTrumpMergePolicy as AnyObject))
    }
}
