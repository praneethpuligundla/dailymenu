import Foundation

/// Warm, non-judgmental microcopy constants
/// All copy avoids: streaks, guilt, pressure, productivity language
/// All copy celebrates: small wins, permission, kindness to self
enum Copy {
    // MARK: - Onboarding

    static let onboardingWelcome = "Welcome to your menu of small joys"
    static let onboardingTagline = "Fun, not a chore"
    static let onboardingDescription = "Pick your time and energy, get 1-3 ready-to-do ideas. No pressure, no streaks—just attainable moments."

    // MARK: - Empty States

    static let noActivitiesTitle = "Nothing here yet"
    static let noActivitiesMessage = "We're loading your menu of ideas..."
    static let noFavoritesTitle = "No favorites yet"
    static let noFavoritesMessage = "Tap the heart on any activity to save it here."
    static let noHistoryTitle = "No completions yet"
    static let noHistoryMessage = "When you mark 'I did this,' it'll show up here."

    // MARK: - Supportive Microcopy

    static let activityCompleted = "Nice, that counts"
    static let activitySaved = "Saved to favorites"
    static let activityHidden = "Hidden from suggestions"
    static let newSuggestion = "Show me something else"
    static let doThis = "Do this"
    static let iDidThis = "I did this"

    // MARK: - Permissions & Choices

    static let notificationsPermissionTitle = "Gentle reminders?"
    static let notificationsPermissionMessage = "Get a warm nudge when you choose. You can always turn it off."
    static let notificationsOptional = "Totally optional"
    static let skipForNow = "Skip for now"
    static let maybeAnotherTime = "Maybe another time"

    // MARK: - Low Battery Mode

    static let lowBatteryIntro = "Low energy? That's okay."
    static let lowBatteryMessage = "These activities are designed for when you need something gentle."
    static let restIsValid = "Rest counts too"

    // MARK: - Encouragement

    static let tinyJoysAddUp = "Tiny joys add up"
    static let youDidIt = "You did it"
    static let noWrongChoices = "There are no wrong choices here"
    static let permissionToRest = "You have permission to rest"
    static let oneThingIsEnough = "One thing is enough"

    // MARK: - Errors (Warm & Non-Technical)

    static let genericErrorTitle = "Something's not working"
    static let genericErrorMessage = "No worries—try again in a moment."
    static let offlineTitle = "You're offline"
    static let offlineMessage = "Your saved favorites and suggestions still work."
    static let loadingFailed = "Couldn't load that right now. It's okay to try again later."

    // Deferred actions
    static let syncDeferred = "We'll sync when you're back online"
    static let submissionDeferred = "We'll send this when you're back online"

    // MARK: - Settings

    static let settingsTitle = "Settings"
    static let resetDataSectionHeader = "Data Controls"
    static let resetDataButton = "Reset all data"
    static let resetDataFooter = "Clears favorites, history, and preferences. Reloads the seed library. You'll have a few seconds to undo."

    // Double-confirmation flow
    static let resetConfirmTitle = "Start fresh?"
    static let resetConfirmMessage = "This will clear your favorites, history, and preferences. You can always rebuild them."
    static let resetContinue = "Continue"

    static let resetFinalConfirmTitle = "Are you sure?"
    static let resetFinalConfirmMessage = "This can't be undone after 8 seconds. Your seed library will reload automatically."
    static let resetConfirm = "Reset everything"
    static let cancel = "Cancel"

    // Undo toast
    static let resetUndoToast = "Data reset. Tap to undo."
    static let undo = "Undo"

    // Legacy (kept for backward compatibility)
    static let dataResetTitle = "Start fresh?"
    static let dataResetMessage = "This will clear your favorites, history, and preferences. You can always rebuild them."
    static let dataResetConfirm = "Clear everything"
    static let dataResetCancel = "Keep my data"

    // MARK: - Accessibility Labels

    static let closeButton = "Close"
    static let backButton = "Go back"
    static let favoriteButton = "Save to favorites"
    static let unfavoriteButton = "Remove from favorites"
    static let hideActivityButton = "Hide this activity"
    static let expandDetailsButton = "Show details"
    static let collapseDetailsButton = "Hide details"
}
