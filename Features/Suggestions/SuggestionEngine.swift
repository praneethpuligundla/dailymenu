import Foundation
import CoreData

@MainActor
class SuggestionEngine: ObservableObject {
    @Published var suggestions: [ActivityEntity] = []
    @Published var isLoading = false

    private let store: Store
    private var sessionSeenIds: Set<UUID> = []
    private var dismissedActivities: [UUID: Date] = [:]  // ID -> dismissal time
    private let dismissCooldown: TimeInterval = 60 * 60  // 60 minutes

    init(store: Store = .shared) {
        self.store = store
    }

    /// Dismiss an activity - won't appear for 60 minutes
    func dismissActivity(_ activity: ActivityEntity) {
        guard let id = activity.id else { return }
        dismissedActivities[id] = Date()
        cleanupExpiredDismissals()
    }

    /// Check if activity is currently dismissed
    private func isDismissed(_ id: UUID) -> Bool {
        guard let dismissedAt = dismissedActivities[id] else { return false }
        return Date().timeIntervalSince(dismissedAt) < dismissCooldown
    }

    /// Remove expired dismissals
    private func cleanupExpiredDismissals() {
        let now = Date()
        dismissedActivities = dismissedActivities.filter { _, dismissedAt in
            now.timeIntervalSince(dismissedAt) < dismissCooldown
        }
    }

    func fetchSuggestions(time: TimeWindow, energy: EnergyLevel, context: SocialContext, count: Int = 3) {
        isLoading = true
        defer { isLoading = false }

        // Cleanup expired dismissals
        cleanupExpiredDismissals()

        // Begin performance monitoring
        let signpostID = PerformanceMonitor.shared.beginSuggestionLoad()

        // Combine seen IDs and dismissed IDs
        let excludedIds = sessionSeenIds.union(dismissedActivities.keys)

        let predicate = NSPredicate(
            format: "expectedMinutes >= %d AND expectedMinutes <= %d AND energy == %@ AND context == %@ AND NOT (id IN %@)",
            time.minutes.lowerBound,
            time.minutes.upperBound,
            energy.rawValue,
            context.rawValue,
            Array(excludedIds)
        )

        var activities = store.fetchActivities(
            predicate: predicate,
            sortDescriptors: [NSSortDescriptor(keyPath: \ActivityEntity.title, ascending: true)]
        )

        if activities.isEmpty {
            // Reset session seen IDs if pool exhausted (but keep dismissed)
            sessionSeenIds.removeAll()
            let dismissedOnly = Array(dismissedActivities.keys)
            activities = store.fetchActivities(predicate: NSPredicate(
                format: "expectedMinutes >= %d AND expectedMinutes <= %d AND energy == %@ AND context == %@ AND NOT (id IN %@)",
                time.minutes.lowerBound,
                time.minutes.upperBound,
                energy.rawValue,
                context.rawValue,
                dismissedOnly
            ))
        }

        suggestions = Array(activities.shuffled().prefix(count))
        sessionSeenIds.formUnion(suggestions.compactMap(\.id))

        // End performance monitoring
        PerformanceMonitor.shared.endSuggestionLoad(signpostID: signpostID, count: suggestions.count)
    }

    func newSuggestion(time: TimeWindow, energy: EnergyLevel, context: SocialContext) {
        fetchSuggestions(time: time, energy: energy, context: context)
    }
}
