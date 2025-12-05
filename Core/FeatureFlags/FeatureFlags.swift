import Foundation

/// Feature flags with safe defaults (all experimental features OFF)
/// Cloud/network features require explicit opt-in
struct FeatureFlags: Sendable {
    static var shared = FeatureFlags()

    // MARK: - Cloud/AI Features (Opt-in required)

    /// Enable cloud LLM for suggestions (via backend proxy). Default: OFF
    var useCloudLLM: Bool = false

    /// Enable sync to backend. Default: OFF
    var enableSync: Bool = false

    /// Enable public activity submissions. Default: OFF
    var enablePublicSubmissions: Bool = false

    /// Enable downloadable content packs. Default: OFF
    var enableContentPacks: Bool = false

    // MARK: - Growth Features (Staged rollout)

    /// Enable second reminder window. Default: OFF (MVP: single window)
    var enableSecondReminderWindow: Bool = false

    /// Enable 7-30 day history depth. Default: OFF (MVP: basic history)
    var enableGrowthHistory: Bool = false

    // MARK: - Bootstrap

    /// Initialize flags from remote config or defaults
    static func bootstrap() {
        // Hook for remote config or user defaults
        // Defaults keep cloud/offline paths safe
        shared = FeatureFlags()
    }

    /// Check a specific flag
    static func flag(_ keyPath: KeyPath<FeatureFlags, Bool>) -> Bool {
        shared[keyPath: keyPath]
    }
}
