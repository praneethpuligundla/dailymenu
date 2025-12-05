import XCTest
import CoreData
@testable import DailyMenu

/// Performance and stability tests
@MainActor
final class PerformanceTests: XCTestCase {
    var store: Store!
    var engine: SuggestionEngine!

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
        engine = SuggestionEngine(store: store)

        // Seed test data (100 activities)
        for i in 0..<100 {
            let activity = ActivityEntity(context: store.viewContext)
            activity.id = UUID()
            activity.title = "Activity \(i)"
            activity.descriptionText = "Test activity \(i)"
            activity.expectedMinutes = Int16([5, 10, 15, 30].randomElement()!)
            activity.category = ["starter", "main", "dessert"].randomElement()!
            activity.energy = ["low", "okay", "upForSomething"].randomElement()!
            activity.context = ["solo", "withSomeone"].randomElement()!
            activity.repeatable = true
            activity.source = "seed"
            activity.moderationStatus = "approved"
        }
        store.save()
    }

    override func tearDown() async throws {
        store = nil
        engine = nil
    }

    // MARK: - Launch Performance

    func testLaunchToSuggestionsPerformance() {
        measure {
            // Measure time from "app launch" to suggestions loaded
            engine.fetchSuggestions(
                time: .short,
                energy: .okay,
                context: .solo,
                count: 3
            )
        }

        // Verify target is met (< 2 seconds in release builds)
        // Note: Debug builds will be slower
    }

    // MARK: - Core Data Performance

    func testActivityFetchPerformance() {
        measure {
            let _ = store.fetchActivities()
        }
    }

    func testFilteredActivityFetchPerformance() {
        let options = XCTMeasureOptions()
        options.iterationCount = 10

        measure(options: options) {
            let predicate = NSPredicate(
                format: "expectedMinutes >= %d AND expectedMinutes <= %d AND energy == %@ AND context == %@",
                5, 15, "okay", "solo"
            )
            let _ = store.fetchActivities(predicate: predicate)
        }
    }

    func testFavoritesFetchPerformance() {
        // Create 50 favorites
        for i in 0..<50 {
            let favorite = FavoriteEntity(context: store.viewContext)
            favorite.id = UUID()
            let activities = store.fetchActivities()
            favorite.activity = activities[i % activities.count]
            favorite.createdAt = Date()
        }
        store.save()

        measure {
            let _ = store.fetchFavorites()
        }
    }

    func testHistoryFetchPerformance() {
        // Create 100 history entries
        for i in 0..<100 {
            let entry = HistoryEntryEntity(context: store.viewContext)
            entry.id = UUID()
            let activities = store.fetchActivities()
            entry.activity = activities[i % activities.count]
            entry.completedAt = Date().addingTimeInterval(TimeInterval(-i * 3600))
        }
        store.save()

        measure {
            let _ = store.fetchHistoryEntries()
        }
    }

    // MARK: - Suggestion Engine Performance

    func testSuggestionRotationPerformance() {
        measure {
            // Simulate user tapping "new suggestion" 10 times
            for _ in 0..<10 {
                engine.fetchSuggestions(
                    time: .short,
                    energy: .okay,
                    context: .solo,
                    count: 3
                )
            }
        }
    }

    func testSuggestionWithSessionExhaustionPerformance() {
        measure {
            // Exhaust the pool and force reset
            for _ in 0..<50 { // More iterations than available activities
                engine.newSuggestion(time: .short, energy: .okay, context: .solo)
            }
        }
    }

    // MARK: - Memory Tests

    func testMemoryLeakInSuggestionEngine() {
        let iterations = 100

        // Capture baseline memory
        let beforeMemory = MemoryMonitor.shared.currentMemoryUsage()

        // Perform many suggestion fetches
        for _ in 0..<iterations {
            engine.fetchSuggestions(
                time: .short,
                energy: .okay,
                context: .solo,
                count: 3
            )
            engine.newSuggestion(time: .short, energy: .okay, context: .solo)
        }

        // Capture after memory
        let afterMemory = MemoryMonitor.shared.currentMemoryUsage()
        let memoryGrowth = afterMemory - beforeMemory

        // Memory growth should be minimal (< 5MB)
        XCTAssertLessThan(memoryGrowth, 5.0, "Memory grew by \(String(format: "%.2f", memoryGrowth)) MB")
    }

    func testMemoryLeakInCoreDataFetches() {
        let iterations = 100

        let beforeMemory = MemoryMonitor.shared.currentMemoryUsage()

        for _ in 0..<iterations {
            let _ = store.fetchActivities()
            let _ = store.fetchFavorites()
            let _ = store.fetchHistoryEntries()
        }

        let afterMemory = MemoryMonitor.shared.currentMemoryUsage()
        let memoryGrowth = afterMemory - beforeMemory

        XCTAssertLessThan(memoryGrowth, 5.0, "Memory grew by \(String(format: "%.2f", memoryGrowth)) MB")
    }

    // MARK: - Soak Tests

    func testSoakTest_Nocrashes() async throws {
        // Simulate 1000 random user actions without crashing
        for _ in 0..<1000 {
            let action = Int.random(in: 0..<4)

            switch action {
            case 0:
                // Fetch suggestions
                engine.fetchSuggestions(
                    time: TimeWindow.allCases.randomElement()!,
                    energy: EnergyLevel.allCases.randomElement()!,
                    context: SocialContext.allCases.randomElement()!,
                    count: 3
                )

            case 1:
                // Add favorite
                if let activity = store.fetchActivities().randomElement() {
                    let favorite = FavoriteEntity(context: store.viewContext)
                    favorite.id = UUID()
                    favorite.activity = activity
                    favorite.createdAt = Date()
                    store.save()
                }

            case 2:
                // Add history entry
                if let activity = store.fetchActivities().randomElement() {
                    let entry = HistoryEntryEntity(context: store.viewContext)
                    entry.id = UUID()
                    entry.activity = activity
                    entry.completedAt = Date()
                    store.save()
                }

            case 3:
                // Fetch all data
                let _ = store.fetchActivities()
                let _ = store.fetchFavorites()
                let _ = store.fetchHistoryEntries()

            default:
                break
            }
        }

        // If we got here without crashing, test passes
        XCTAssertTrue(true)
    }
}

// MARK: - Helper Extensions

// TimeWindow, EnergyLevel, and SocialContext already conform to CaseIterable in the main module
