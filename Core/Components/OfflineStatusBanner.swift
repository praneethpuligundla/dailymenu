import SwiftUI

/// Subtle offline status banner
struct OfflineStatusBanner: View {
    @ObservedObject var offlineManager: OfflineManager

    var body: some View {
        if offlineManager.isOffline {
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash")
                    .font(Theme.captionFont())
                Text(Copy.offlineTitle)
                    .font(Theme.captionFont())
            }
            .foregroundColor(Theme.subtleText)
            .padding(.horizontal, Theme.paddingSmall)
            .padding(.vertical, 6)
            .background(Theme.surface.opacity(0.95))
            .cornerRadius(Theme.chipCornerRadius)
            .shadow(radius: 1)
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }
}

/// Modifier to add offline status banner to any view
struct OfflineStatusModifier: ViewModifier {
    @StateObject private var offlineManager = OfflineManager()

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                OfflineStatusBanner(offlineManager: offlineManager)
                    .padding(.top, 8)
            }
            .environmentObject(offlineManager)
    }
}

extension View {
    /// Add offline status monitoring and banner to this view
    func withOfflineStatus() -> some View {
        modifier(OfflineStatusModifier())
    }
}
