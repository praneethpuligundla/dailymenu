import XCTest
import CoreData
@testable import DailyMenu

/// Tests for sync conflict resolution and merge logic
@MainActor
final class SyncConflictResolverTests: XCTestCase {
    var store: Store!
    var resolver: SyncConflictResolver!
    var testActivity: ActivityEntity!

    override func setUp() async throws {
        // Create in-memory store for testing
        let container = NSPersistentContainer(name: "DailyMenu")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            XCTAssertNil(error)
        }

        store = Store(container: container)
        resolver = SyncConflictResolver(store: store)

        // Create test activity
        testActivity = ActivityEntity(context: store.viewContext)
        testActivity.id = UUID()
        testActivity.title = "Test Activity"
        testActivity.descriptionText = "Test description"
        testActivity.expectedMinutes = 10
        testActivity.category = "starter"
        testActivity.energy = "low"
        testActivity.context = "solo"
        testActivity.repeatable = true
        testActivity.source = "seed"
        testActivity.moderationStatus = "approved"
        store.save()
    }

    override func tearDown() async throws {
        store = nil
        resolver = nil
        testActivity = nil
    }

    // MARK: - Favorites Merge Tests

    func testMergeFavorites_NewRemoteRecord_CreatesLocally() async throws {
        // Given: No local favorites
        XCTAssertEqual(store.fetchFavorites().count, 0)

        // When: Merging remote favorites
        let remoteFavorite = RemoteFavorite(
            id: UUID(),
            activityId: testActivity.id!,
            createdAt: Date(),
            updatedAt: Date(),
            etag: "etag1"
        )
        let result = resolver.mergeFavorites(remote: [remoteFavorite])

        // Then: New favorite created
        XCTAssertEqual(result.created, 1)
        XCTAssertEqual(result.updated, 0)
        XCTAssertEqual(result.conflicts, 0)
        XCTAssertEqual(store.fetchFavorites().count, 1)
    }

    func testMergeFavorites_LocalWinsWhenEqualTimestamps() async throws {
        // Given: Local favorite exists
        let favoriteId = UUID()
        let localFavorite = FavoriteEntity(context: store.viewContext)
        localFavorite.id = favoriteId
        localFavorite.activity = testActivity
        localFavorite.createdAt = Date()
        localFavorite.updatedAt = Date(timeIntervalSinceNow: -100)
        store.save()

        // When: Merging remote with same timestamp
        let remoteFavorite = RemoteFavorite(
            id: favoriteId,
            activityId: testActivity.id!,
            createdAt: Date(),
            updatedAt: localFavorite.updatedAt,
            etag: "etag1"
        )
        let result = resolver.mergeFavorites(remote: [remoteFavorite])

        // Then: Local wins (conflict recorded)
        XCTAssertEqual(result.created, 0)
        XCTAssertEqual(result.updated, 0)
        XCTAssertEqual(result.conflicts, 1)
        XCTAssertTrue(result.hasConflicts)
    }

    func testMergeFavorites_ServerWinsWhenNewer() async throws {
        // Given: Local favorite with older timestamp
        let favoriteId = UUID()
        let localFavorite = FavoriteEntity(context: store.viewContext)
        localFavorite.id = favoriteId
        localFavorite.activity = testActivity
        localFavorite.createdAt = Date()
        localFavorite.updatedAt = Date(timeIntervalSinceNow: -200)
        store.save()

        // When: Merging remote with newer timestamp
        let newerDate = Date(timeIntervalSinceNow: -50)
        let remoteFavorite = RemoteFavorite(
            id: favoriteId,
            activityId: testActivity.id!,
            createdAt: Date(),
            updatedAt: newerDate,
            etag: "etag2"
        )
        let result = resolver.mergeFavorites(remote: [remoteFavorite])

        // Then: Server wins (updated)
        XCTAssertEqual(result.created, 0)
        XCTAssertEqual(result.updated, 1)
        XCTAssertEqual(result.conflicts, 0)

        let updated = store.fetchFavorites().first
        XCTAssertEqual(updated?.updatedAt, newerDate)
    }

    // MARK: - History Merge Tests

    func testMergeHistory_NewRemoteRecord_CreatesLocally() async throws {
        // Given: No local history entries
        XCTAssertEqual(store.fetchHistoryEntries().count, 0)

        // When: Merging remote history
        let remoteEntry = RemoteHistoryEntry(
            id: UUID(),
            activityId: testActivity.id!,
            completedAt: Date(),
            updatedAt: Date(),
            etag: "etag1"
        )
        let result = resolver.mergeHistoryEntries(remote: [remoteEntry])

        // Then: New entry created
        XCTAssertEqual(result.created, 1)
        XCTAssertEqual(result.updated, 0)
        XCTAssertEqual(result.conflicts, 0)
        XCTAssertEqual(store.fetchHistoryEntries().count, 1)
    }

    func testMergeHistory_OutOfOrderUpdates_HandlesCorrectly() async throws {
        // Given: Local entry with timestamp T2
        let entryId = UUID()
        let localEntry = HistoryEntryEntity(context: store.viewContext)
        localEntry.id = entryId
        localEntry.activity = testActivity
        localEntry.completedAt = Date()
        localEntry.updatedAt = Date(timeIntervalSinceNow: -100) // T2
        store.save()

        // When: Remote updates arrive out of order (T1, then T3)
        let olderRemote = RemoteHistoryEntry(
            id: entryId,
            activityId: testActivity.id!,
            completedAt: Date(),
            updatedAt: Date(timeIntervalSinceNow: -200), // T1 (older)
            etag: "etag1"
        )

        let newerRemote = RemoteHistoryEntry(
            id: entryId,
            activityId: testActivity.id!,
            completedAt: Date(),
            updatedAt: Date(timeIntervalSinceNow: -50), // T3 (newer)
            etag: "etag2"
        )

        // Process older update first (should keep local)
        let result1 = resolver.mergeHistoryEntries(remote: [olderRemote])
        XCTAssertEqual(result1.conflicts, 1)
        XCTAssertEqual(result1.updated, 0)

        // Process newer update (should update from server)
        let result2 = resolver.mergeHistoryEntries(remote: [newerRemote])
        XCTAssertEqual(result2.updated, 1)
        XCTAssertEqual(result2.conflicts, 0)
    }

    // MARK: - Hidden Activities Merge Tests

    func testMergeHiddenActivities_UnionMerge() async throws {
        // Given: Local has some hidden activities
        let localHidden = [UUID(), UUID()]
        let prefs = store.fetchOrCreateUserPrefs()
        if let encoded = try? JSONEncoder().encode(localHidden),
           let json = String(data: encoded, encoding: .utf8) {
            prefs.excludedCategories = json
            store.save()
        }

        // When: Merging remote hidden activities (partial overlap)
        let remoteHidden = [localHidden[0], UUID()] // One overlap, one new
        let result = resolver.mergeHiddenActivities(remote: remoteHidden)

        // Then: Union of local and remote
        XCTAssertEqual(result.updated, 1)

        let updatedPrefs = store.fetchUserPrefs()!
        let merged = try JSONDecoder().decode([UUID].self, from: updatedPrefs.excludedCategories!.data(using: .utf8)!)
        XCTAssertEqual(merged.count, 3) // 2 local + 1 new remote
    }

    // MARK: - Merge Result Tests

    func testMergeResult_Summary() {
        let result = MergeResult<FavoriteEntity>(created: 5, updated: 3, conflicts: 2)
        XCTAssertEqual(result.total, 8)
        XCTAssertTrue(result.hasConflicts)
        XCTAssertEqual(result.summary, "5 created, 3 updated, 2 conflicts (local kept)")
    }

    func testMergeResult_NoChanges() {
        let result = MergeResult<FavoriteEntity>(created: 0, updated: 0, conflicts: 0)
        XCTAssertEqual(result.total, 0)
        XCTAssertFalse(result.hasConflicts)
        XCTAssertEqual(result.summary, "No changes")
    }
}

// MARK: - Core Data Extensions for Testing

extension FavoriteEntity {
    var updatedAt: Date? {
        get { value(forKey: "updatedAt") as? Date }
        set { setValue(newValue, forKey: "updatedAt") }
    }
}

extension HistoryEntryEntity {
    var updatedAt: Date? {
        get { value(forKey: "updatedAt") as? Date }
        set { setValue(newValue, forKey: "updatedAt") }
    }
}

extension UserPrefsEntity {
    var updatedAt: Date? {
        get { value(forKey: "updatedAt") as? Date }
        set { setValue(newValue, forKey: "updatedAt") }
    }

    var excludedCategories: String? {
        get { value(forKey: "excludedCategories") as? String }
        set { setValue(newValue, forKey: "excludedCategories") }
    }

    var preferredContexts: String? {
        get { value(forKey: "preferredContexts") as? String }
        set { setValue(newValue, forKey: "preferredContexts") }
    }
}
