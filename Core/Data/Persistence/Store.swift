import Foundation
import CoreData
import OSLog

/// Core Data persistence store with background saves and lightweight migration
@MainActor
final class Store: ObservableObject {
    static let shared = Store()

    private let log = Logger(subsystem: "com.dailymenu.app", category: "data")

    /// The persistent container for the application's Core Data stack
    let container: NSPersistentContainer

    /// Main context for UI operations (main queue)
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    private convenience init() {
        self.init(container: NSPersistentContainer(name: "DailyMenu"))
    }

    /// Internal initializer for dependency injection (testing)
    internal init(container: NSPersistentContainer) {
        self.container = container

        // Configure persistent store description
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve persistent store description")
        }

        // Disable CloudKit integration (local-only store)
        description.cloudKitContainerOptions = nil

        // Enable persistent history tracking for background context coordination
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        // Enable lightweight migration
        description.shouldMigrateStoreAutomatically = true
        description.shouldInferMappingModelAutomatically = true

        // Load persistent stores
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // Log error and fail fast in debug builds
                self.log.error("Core Data store failed to load: \(error), \(error.userInfo)")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            self.log.info("Core Data store loaded successfully from: \(storeDescription.url?.path ?? "unknown")")
        }

        // Configure view context for automatic merging
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        log.info("Store initialized with lightweight migration and background saves enabled")
    }

    /// Create a new background context for async operations
    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    /// Save the view context if it has changes
    func save() {
        guard viewContext.hasChanges else {
            log.debug("No changes to save in view context")
            return
        }

        do {
            try viewContext.save()
            log.debug("View context saved successfully")
        } catch {
            let nsError = error as NSError
            log.error("Failed to save view context: \(nsError), \(nsError.userInfo)")
            // In production, consider presenting an error to the user
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    /// Save a background context
    func saveBackground(_ context: NSManagedObjectContext) async throws {
        guard context.hasChanges else {
            log.debug("No changes to save in background context")
            return
        }

        try await context.perform {
            do {
                try context.save()
                self.log.debug("Background context saved successfully")
            } catch {
                self.log.error("Failed to save background context: \(error)")
                throw error
            }
        }
    }
}

// MARK: - Type-Safe Fetchers

extension Store {
    /// Fetch all activities matching a predicate
    func fetchActivities(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor] = []) -> [ActivityEntity] {
        let request = ActivityEntity.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors

        do {
            return try viewContext.fetch(request)
        } catch {
            log.error("Failed to fetch activities: \(error)")
            return []
        }
    }

    /// Fetch all favorites
    func fetchFavorites(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \FavoriteEntity.createdAt, ascending: false)]) -> [FavoriteEntity] {
        let request = FavoriteEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors

        do {
            return try viewContext.fetch(request)
        } catch {
            log.error("Failed to fetch favorites: \(error)")
            return []
        }
    }

    /// Fetch history entries
    func fetchHistoryEntries(sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(keyPath: \HistoryEntryEntity.completedAt, ascending: false)]) -> [HistoryEntryEntity] {
        let request = HistoryEntryEntity.fetchRequest()
        request.sortDescriptors = sortDescriptors

        do {
            return try viewContext.fetch(request)
        } catch {
            log.error("Failed to fetch history entries: \(error)")
            return []
        }
    }

    /// Fetch user preferences (singleton pattern - one record)
    func fetchUserPrefs() -> UserPrefsEntity? {
        let request = UserPrefsEntity.fetchRequest()
        request.fetchLimit = 1

        do {
            return try viewContext.fetch(request).first
        } catch {
            log.error("Failed to fetch user prefs: \(error)")
            return nil
        }
    }

    /// Fetch or create user preferences
    func fetchOrCreateUserPrefs() -> UserPrefsEntity {
        if let existing = fetchUserPrefs() {
            return existing
        }

        let prefs = UserPrefsEntity(context: viewContext)
        prefs.id = UUID()
        save()
        log.info("Created new user prefs record")
        return prefs
    }
}

// MARK: - Preview Support

#if DEBUG
extension Store {
    /// In-memory store for SwiftUI previews
    static let preview: Store = {
        let store = Store()
        store.container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        return store
    }()
}
#endif
