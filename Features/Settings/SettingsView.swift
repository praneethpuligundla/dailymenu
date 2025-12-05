import SwiftUI

struct SettingsView: View {
    @StateObject private var resetManager = DataResetManager()
    @State private var showingFirstConfirmation = false
    @State private var showingSecondConfirmation = false

    var body: some View {
        NavigationView {
            List {
                Section {
                    Button(role: .destructive) {
                        showingFirstConfirmation = true
                    } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise")
                            Text(Copy.resetDataButton)
                        }
                    }
                } header: {
                    Text(Copy.resetDataSectionHeader)
                } footer: {
                    Text(Copy.resetDataFooter)
                }

                Section {
                    Text("Version \(Bundle.main.appVersionString)")
                        .font(Theme.captionFont())
                        .foregroundColor(Theme.subtleText)
                }
            }
            .navigationTitle(Copy.settingsTitle)
            .alert(Copy.resetConfirmTitle, isPresented: $showingFirstConfirmation) {
                Button(Copy.cancel, role: .cancel) { }
                Button(Copy.resetContinue, role: .destructive) {
                    showingSecondConfirmation = true
                }
            } message: {
                Text(Copy.resetConfirmMessage)
            }
            .alert(Copy.resetFinalConfirmTitle, isPresented: $showingSecondConfirmation) {
                Button(Copy.cancel, role: .cancel) { }
                Button(Copy.resetConfirm, role: .destructive) {
                    resetManager.resetAllData()
                }
            } message: {
                Text(Copy.resetFinalConfirmMessage)
            }
            .overlay(alignment: .bottom) {
                if resetManager.showingUndoToast {
                    UndoToast(
                        message: Copy.resetUndoToast,
                        onUndo: {
                            resetManager.undoReset()
                        }
                    )
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom))
                }
            }
        }
    }
}

// MARK: - Undo Toast Component

struct UndoToast: View {
    let message: String
    let onUndo: () -> Void

    var body: some View {
        HStack {
            Text(message)
                .font(Theme.bodyFont())
                .foregroundColor(.white)
            Spacer()
            Button(Copy.undo) {
                onUndo()
            }
            .font(Theme.bodyFont().bold())
            .foregroundColor(.white)
        }
        .padding(Theme.padding)
        .background(Color.black.opacity(0.85))
        .cornerRadius(Theme.cornerRadius)
        .shadow(radius: 4)
        .padding(.horizontal, Theme.padding)
    }
}

// MARK: - Bundle Extension for Version

extension Bundle {
    var appVersionString: String {
        let version = infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
