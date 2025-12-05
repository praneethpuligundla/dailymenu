import SwiftUI

/// Toast for network-deferred actions
struct DeferredActionToast: View {
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            HStack {
                Image(systemName: "clock.arrow.circlepath")
                    .font(Theme.bodyFont())
                Text(message)
                    .font(Theme.bodyFont())
            }
            .foregroundColor(.white)
            .padding(Theme.padding)
            .background(Color.orange.opacity(0.9))
            .cornerRadius(Theme.cornerRadius)
            .shadow(radius: 4)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onAppear {
                // Auto-dismiss after 3 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
        }
    }
}

/// View model for managing deferred action toasts
@MainActor
final class DeferredActionManager: ObservableObject {
    @Published var currentMessage: String?
    @Published var isShowingToast: Bool = false

    func showDeferredMessage(_ message: String) {
        currentMessage = message
        withAnimation {
            isShowingToast = true
        }
    }

    func showSyncDeferred() {
        showDeferredMessage(Copy.syncDeferred)
    }

    func showSubmissionDeferred() {
        showDeferredMessage(Copy.submissionDeferred)
    }
}
