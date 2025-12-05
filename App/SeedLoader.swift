import Foundation

/// Loads initial seed data into the app's store on first launch.
struct SeedLoader {
    private let store: Store
    private let userDefaults: UserDefaults
    private let seedFlagKey = "hasSeededInitialData"

    init(store: Store, userDefaults: UserDefaults = .standard) {
        self.store = store
        self.userDefaults = userDefaults
    }

    /// Loads seed data once. Subsequent calls are no-ops.
    @MainActor
    func loadSeedIfNeeded() {
        if userDefaults.bool(forKey: seedFlagKey) { return }

        // Perform your seeding here. This is a placeholder that simply marks the seed complete.
        // Example: insert default entities into Core Data using store.context and save.
        // do {
        //     // create objects
        //     try store.context.save()
        // } catch {
        //     print("Seeding failed: \(error)")
        //     return
        // }

        userDefaults.set(true, forKey: seedFlagKey)
    }
}
