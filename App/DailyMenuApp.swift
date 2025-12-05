import SwiftUI
import CoreData

@main
struct DailyMenuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var isReady = false

    init() {
        FeatureFlags.bootstrap()
    }

    var body: some Scene {
        WindowGroup {
            if isReady {
                HomeView()
            } else {
                // Loading state while seed data loads
                ZStack {
                    Theme.cream.ignoresSafeArea()
                    VStack(spacing: 12) {
                        Text("Daily Menu")
                            .font(Theme.displayFont(size: 32))
                            .foregroundColor(Theme.ink)
                        Text("tiny joys, served fresh")
                            .font(.system(size: 14, weight: .regular, design: .serif))
                            .italic()
                            .foregroundColor(Theme.clay)
                    }
                }
                .task {
                    let seedLoader = SeedLoader(store: Store.shared)
                    seedLoader.loadSeedIfNeeded()
                    isReady = true
                }
            }
        }
    }
}
