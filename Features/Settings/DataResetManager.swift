import Foundation
import CoreData

/// Manages data reset operations with undo support
@MainActor
final class DataResetManager: ObservableObject {
    @Published var canUndo: Bool = false
    @Published var showingUndoToast: Bool = false

    private let store: Store
    private let seedLoader: SeedLoader
    private var undoSnapshot: ResetSnapshot?
    private var undoTimer: Timer?

    init(store: Store = .shared, seedLoader: SeedLoader? = nil) {
        self.store = store
        self.seedLoader = seedLoader ?? SeedLoader(store: store)
    }

    /// Reset all user data with undo capability
    func resetAllData() {
        // Create snapshot for undo
        undoSnapshot = captureSnapshot()

        // Clear user data
        clearFavorites()
        clearHistory()
        clearPreferences()
        clearKeychainTokens()

        // Reset feature flags to defaults
        FeatureFlags.bootstrap()

        // Reload seed data
        resetSeedFlag()
        seedLoader.loadSeedIfNeeded()

        // Offer brief undo
        showUndoToast()
    }

    /// Undo the last reset operation
    func undoReset() {
        guard let snapshot = undoSnapshot else { return }

        // Restore favorites
        for favorite in snapshot.favorites {
            let fav = FavoriteEntity(context: store.viewContext)
            fav.id = favorite.id
            fav.activity = store.fetchActivities(predicate: NSPredicate(format: "id == %@", favorite.activityId as CVarArg)).first
            fav.createdAt = favorite.createdAt
        }

        // Restore history
        for entry in snapshot.historyEntries {
            let historyEntry = HistoryEntryEntity(context: store.viewContext)
            historyEntry.id = entry.id
            historyEntry.activity = store.fetchActivities(predicate: NSPredicate(format: "id == %@", entry.activityId as CVarArg)).first
            historyEntry.completedAt = entry.completedAt
        }

        // Restore preferences
        if let prefs = snapshot.userPrefs {
            let userPrefs = UserPrefsEntity(context: store.viewContext)
            userPrefs.id = prefs.id
            userPrefs.preferredContexts = prefs.preferredContexts
            userPrefs.excludedCategories = prefs.excludedCategories
            userPrefs.updatedAt = prefs.updatedAt
        }

        store.save()

        // Clear undo state
        undoSnapshot = nil
        canUndo = false
        showingUndoToast = false
        undoTimer?.invalidate()
    }

    // MARK: - Private Helpers

    private func captureSnapshot() -> ResetSnapshot {
        let favorites = store.fetchFavorites().map { favorite in
            FavoriteSnapshot(
                id: favorite.id ?? UUID(),
                activityId: favorite.activity?.id ?? UUID(),
                createdAt: favorite.createdAt ?? Date()
            )
        }

        let historyEntries = store.fetchHistoryEntries().map { entry in
            HistorySnapshot(
                id: entry.id ?? UUID(),
                activityId: entry.activity?.id ?? UUID(),
                completedAt: entry.completedAt ?? Date()
            )
        }

        let userPrefs = store.fetchUserPrefs()
        let prefsSnapshot: UserPrefsSnapshot? = if let prefs = userPrefs {
            UserPrefsSnapshot(
                id: prefs.id ?? UUID(),
                preferredContexts: prefs.preferredContexts,
                excludedCategories: prefs.excludedCategories,
                updatedAt: prefs.updatedAt ?? Date()
            )
        } else {
            nil
        }

        return ResetSnapshot(
            favorites: favorites,
            historyEntries: historyEntries,
            userPrefs: prefsSnapshot
        )
    }

    private func clearFavorites() {
        let favorites = store.fetchFavorites()
        for favorite in favorites {
            store.viewContext.delete(favorite)
        }
        store.save()
    }

    private func clearHistory() {
        let entries = store.fetchHistoryEntries()
        for entry in entries {
            store.viewContext.delete(entry)
        }
        store.save()
    }

    private func clearPreferences() {
        if let prefs = store.fetchUserPrefs() {
            store.viewContext.delete(prefs)
            store.save()
        }
    }

    private func clearKeychainTokens() {
        // Secure wipe of any stored tokens
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "com.dailymenu.tokens"
        ]
        SecItemDelete(query as CFDictionary)
    }

    private func resetSeedFlag() {
        UserDefaults.standard.removeObject(forKey: "com.dailymenu.seedLoaded")
    }

    private func showUndoToast() {
        canUndo = true
        showingUndoToast = true

        // Auto-dismiss after 8 seconds
        undoTimer?.invalidate()
        undoTimer = Timer.scheduledTimer(withTimeInterval: 8.0, repeats: false) { [weak self] _ in
            self?.canUndo = false
            self?.showingUndoToast = false
            self?.undoSnapshot = nil
        }
    }
}

// MARK: - Snapshot Models

struct ResetSnapshot {
    let favorites: [FavoriteSnapshot]
    let historyEntries: [HistorySnapshot]
    let userPrefs: UserPrefsSnapshot?
}

struct FavoriteSnapshot {
    let id: UUID
    let activityId: UUID
    let createdAt: Date
}

struct HistorySnapshot {
    let id: UUID
    let activityId: UUID
    let completedAt: Date
}

struct UserPrefsSnapshot {
    let id: UUID
    let preferredContexts: String?
    let excludedCategories: String?
    let updatedAt: Date
}
