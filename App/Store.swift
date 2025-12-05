import Foundation
import CoreData

/// A minimal app-wide store placeholder. Expand with your real persistence as needed.
final class Store {
    static let shared = Store()

    // Example Core Data stack placeholder. Replace with your actual stack or SwiftData.
    lazy var persistentContainer: NSPersistentContainer = {
        // Use a generic name; replace with your actual model name if available.
        let container = NSPersistentContainer(name: "DailyMenuModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("Unresolved error loading persistent stores: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() {}
}
