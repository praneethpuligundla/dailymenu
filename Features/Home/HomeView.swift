import SwiftUI

// MARK: - HomeView
// The Paper Menu — A warm, handcrafted interface for discovering tiny joys

struct HomeView: View {

    // MARK: - Filter Option Types

    enum TimeOption: String, CaseIterable, Identifiable {
        case quick = "5 min"
        case moderate = "15 min"
        case leisurely = "30+"

        var id: String { rawValue }
        var minutes: Int {
            switch self {
            case .quick: return 5
            case .moderate: return 15
            case .leisurely: return 30
            }
        }
        var label: String {
            switch self {
            case .quick: return "Quick bite"
            case .moderate: return "A nice break"
            case .leisurely: return "Take your time"
            }
        }
        var timeWindow: TimeWindow {
            switch self {
            case .quick: return .short
            case .moderate: return .medium
            case .leisurely: return .long
            }
        }
    }

    enum EnergyOption: String, CaseIterable, Identifiable {
        case low = "Cozy"
        case okay = "Steady"
        case up = "Buzzing"

        var id: String { rawValue }
        var energy: Activity.Energy {
            switch self {
            case .low: return .low
            case .okay: return .okay
            case .up: return .upForSomething
            }
        }
        var energyLevel: EnergyLevel {
            switch self {
            case .low: return .low
            case .okay: return .okay
            case .up: return .upForSomething
            }
        }
        var icon: String {
            switch self {
            case .low: return "moon.stars"
            case .okay: return "sun.haze"
            case .up: return "bolt.fill"
            }
        }
    }

    enum ContextOption: String, CaseIterable, Identifiable {
        case solo = "Just me"
        case withSomeone = "With company"

        var id: String { rawValue }
        var context: Activity.Context {
            switch self {
            case .solo: return .solo
            case .withSomeone: return .withSomeone
            }
        }
        var socialContext: SocialContext {
            switch self {
            case .solo: return .solo
            case .withSomeone: return .withSomeone
            }
        }
    }

    // MARK: - State

    @StateObject private var suggestionEngine = SuggestionEngine()
    @StateObject private var activityImporter = AIActivityImporter()
    @Environment(\.scenePhase) private var scenePhase
    @State private var time: TimeOption = .moderate
    @State private var energy: EnergyOption = .okay
    @State private var context: ContextOption = .solo
    @State private var showFilters = false
    @State private var cardAppeared = false
    @State private var isFavorited = false
    @State private var showCompletedToast = false
    @State private var showAIAppPicker = false
    @State private var showImportedToast = false
    @State private var importedCount = 0

    // MARK: - Computed

    private var currentSuggestion: ActivityEntity? {
        suggestionEngine.suggestions.first
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerSection
                    filtersSection

                    if let activity = currentSuggestion {
                        MenuCardView(
                            title: activity.title ?? "Something nice",
                            description: activity.descriptionText ?? "A small moment of joy awaits.",
                            minutes: Int(activity.expectedMinutes),
                            energyLabel: energy.rawValue,
                            contextLabel: context.rawValue,
                            isFavorited: isFavorited,
                            onSelect: { selectActivity(activity) },
                            onRefresh: { fetchNewSuggestion() },
                            onFavorite: { toggleFavorite(activity) },
                            onDismiss: { dismissSuggestion() },
                            onAskAI: { showAIOptions() }
                        )
                        .padding(.horizontal, 16)
                        .accessibilityIdentifier("menuCard")
                    } else {
                        // Loading or empty state
                        MenuCardView(
                            title: "Finding something nice...",
                            description: "Looking for the perfect activity for you.",
                            minutes: time.minutes,
                            energyLabel: energy.rawValue,
                            contextLabel: context.rawValue,
                            onRefresh: { fetchNewSuggestion() }
                        )
                        .padding(.horizontal, 16)
                        .redacted(reason: suggestionEngine.isLoading ? .placeholder : [])
                    }
                }
                .padding(.vertical, 16)
            }
            .background(Theme.cream.ignoresSafeArea())

            // Completed toast overlay
            if showCompletedToast {
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                        Text("Nice! Activity completed")
                            .font(Theme.labelFont(size: 15))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Theme.forest)
                            .shadow(color: Theme.forest.opacity(0.3), radius: 10, y: 5)
                    )
                    .padding(.bottom, 40)
                    .accessibilityIdentifier("completedToast")
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            // Imported toast overlay
            if showImportedToast {
                VStack {
                    Spacer()
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                        Text("Imported \(importedCount) activit\(importedCount == 1 ? "y" : "ies") from AI")
                            .font(Theme.labelFont(size: 15))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(Theme.mustard)
                            .shadow(color: Theme.mustard.opacity(0.3), radius: 10, y: 5)
                    )
                    .padding(.bottom, 40)
                    .accessibilityIdentifier("importedToast")
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            fetchNewSuggestion()
            checkForImports()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                checkForImports()
            }
        }
        .onChange(of: time) { _, _ in fetchNewSuggestion() }
        .onChange(of: energy) { _, _ in fetchNewSuggestion() }
        .onChange(of: context) { _, _ in fetchNewSuggestion() }
        .confirmationDialog("Get AI Suggestion", isPresented: $showAIAppPicker, titleVisibility: .visible) {
            ForEach(AIAppLauncher.AIApp.allCases) { app in
                Button(app.rawValue) {
                    openAIApp(app)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Choose an AI app to generate a personalized activity suggestion. The prompt will be copied to your clipboard.")
        }
    }

    // MARK: - Actions

    private func fetchNewSuggestion() {
        suggestionEngine.fetchSuggestions(
            time: time.timeWindow,
            energy: energy.energyLevel,
            context: context.socialContext,
            count: 1
        )
        // Check if the new suggestion is already favorited
        if let activity = suggestionEngine.suggestions.first,
           let favorites = activity.favorites as? Set<FavoriteEntity>,
           !favorites.isEmpty {
            isFavorited = true
        } else {
            isFavorited = false
        }
        haptic()
    }

    private func selectActivity(_ activity: ActivityEntity) {
        // Add to history as completed
        let store = Store.shared
        let historyEntry = HistoryEntryEntity(context: store.viewContext)
        historyEntry.id = UUID()
        historyEntry.activity = activity
        historyEntry.completedAt = Date()
        store.save()

        haptic(.medium)

        // Show feedback and get new suggestion
        withAnimation {
            showCompletedToast = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCompletedToast = false
            }
            fetchNewSuggestion()
        }
    }

    private func toggleFavorite(_ activity: ActivityEntity) {
        let store = Store.shared

        // Check if already favorited via relationship
        if let favorites = activity.favorites as? Set<FavoriteEntity>, let existing = favorites.first {
            // Remove from favorites
            store.viewContext.delete(existing)
            isFavorited = false
        } else {
            // Add to favorites
            let favorite = FavoriteEntity(context: store.viewContext)
            favorite.id = UUID()
            favorite.activity = activity
            favorite.createdAt = Date()
            isFavorited = true
        }

        store.save()
        haptic()
    }

    private func dismissSuggestion() {
        // Mark current activity as dismissed (won't appear for 60 minutes)
        if let activity = currentSuggestion {
            suggestionEngine.dismissActivity(activity)
        }
        fetchNewSuggestion()
    }

    private func openAIApp(_ app: AIAppLauncher.AIApp) {
        AIAppLauncher.openWithPrompt(
            app: app,
            time: time.minutes,
            energy: energy.rawValue,
            context: context.rawValue
        )
    }

    private func showAIOptions() {
        showAIAppPicker = true
    }

    private func checkForImports() {
        let count = activityImporter.importPendingActivities()
        if count > 0 {
            importedCount = count
            withAnimation {
                showImportedToast = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    showImportedToast = false
                }
                // Refresh suggestions to include new imports
                fetchNewSuggestion()
            }
        }
    }

    // MARK: - Header Section

    private var headerSection: some View {
        VStack(spacing: 0) {
            Text("Daily Menu")
                .font(Theme.displayFont(size: 32))
                .foregroundColor(Theme.ink)
                .tracking(-0.5)

            Text("tiny joys, served fresh")
                .font(.system(size: 14, weight: .regular, design: .serif))
                .italic()
                .foregroundColor(Theme.clay)
                .padding(.top, 4)

            HStack(spacing: 6) {
                Circle().fill(Theme.terracotta).frame(width: 4, height: 4)
                Circle().fill(Theme.mustard).frame(width: 4, height: 4)
                Circle().fill(Theme.forest).frame(width: 4, height: 4)
            }
            .padding(.top, 10)
        }
    }

    // MARK: - Filters Section

    private var filtersSection: some View {
        VStack(spacing: 16) {
            HStack {
                Text("YOUR ORDER")
                    .font(Theme.monoFont(size: 11))
                    .tracking(3)
                    .foregroundColor(Theme.clay)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showFilters.toggle()
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(showFilters ? "Done" : "Adjust")
                            .font(Theme.labelFont(size: 13))
                        Image(systemName: showFilters ? "chevron.up" : "slider.horizontal.3")
                            .font(.system(size: 11, weight: .semibold))
                    }
                    .foregroundColor(Theme.forest)
                }
            }
            .padding(.horizontal, 20)

            // Current selection pills - tappable to toggle filters
            HStack(spacing: 10) {
                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showFilters.toggle()
                    }
                } label: {
                    FilterPill(icon: "clock", text: time.rawValue, color: Theme.terracotta, isActive: true)
                }

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showFilters.toggle()
                    }
                } label: {
                    FilterPill(icon: energy.icon, text: energy.rawValue, color: Theme.mustard, isActive: true)
                }

                Button {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        showFilters.toggle()
                    }
                } label: {
                    FilterPill(icon: context == .solo ? "person" : "person.2", text: context.rawValue, color: Theme.forest, isActive: true)
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)

            // Expanded filter options
            if showFilters {
                VStack(spacing: 16) {
                    FilterRow(title: "Time") {
                        ForEach(TimeOption.allCases) { option in
                            FilterChip(
                                text: option.rawValue,
                                subtitle: option.label,
                                isSelected: time == option
                            ) {
                                withAnimation(.spring(response: 0.3)) { time = option }
                                haptic()
                            }
                        }
                    }

                    FilterRow(title: "Energy") {
                        ForEach(EnergyOption.allCases) { option in
                            FilterChip(
                                text: option.rawValue,
                                icon: option.icon,
                                isSelected: energy == option
                            ) {
                                withAnimation(.spring(response: 0.3)) { energy = option }
                                haptic()
                            }
                        }
                    }

                    FilterRow(title: "Company") {
                        ForEach(ContextOption.allCases) { option in
                            FilterChip(
                                text: option.rawValue,
                                isSelected: context == option
                            ) {
                                withAnimation(.spring(response: 0.3)) { context = option }
                                haptic()
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity
                ))
            }
        }
    }

    // MARK: - Helpers

    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard Theme.hapticFeedbackEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

// MARK: - Extensions

extension HomeView.TimeOption: CustomStringConvertible {
    var description: String { rawValue }
}

extension HomeView.EnergyOption: CustomStringConvertible {
    var description: String { rawValue }
}

extension HomeView.ContextOption: CustomStringConvertible {
    var description: String { rawValue }
}

// MARK: - Preview

#Preview {
    HomeView()
}
