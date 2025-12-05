import SwiftUI

// MARK: - Menu Card View

struct MenuCardView: View {
    let title: String
    let description: String
    let minutes: Int
    let energyLabel: String
    let contextLabel: String
    var isFavorited: Bool = false

    var onSelect: () -> Void = {}
    var onRefresh: () -> Void = {}
    var onFavorite: () -> Void = {}
    var onDismiss: () -> Void = {}
    var onAskAI: () -> Void = {}

    @State private var cardNumber = Int.random(in: 1...99)

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header with stamp
            cardHeader
                .padding(.bottom, 14)

            DottedDivider()
                .padding(.bottom, 16)

            // Content
            cardContent
                .padding(.bottom, 16)

            DottedDivider()
                .padding(.bottom, 16)

            // Actions
            cardActions
        }
        .padding(20)
        .background(DecorativeCardBackground())
        .shadow(color: Theme.ink.opacity(0.06), radius: 16, x: 0, y: 8)
    }

    // MARK: - Card Header

    private var cardHeader: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("TODAY'S SPECIAL")
                    .font(Theme.monoFont(size: 11))
                    .tracking(2)
                    .foregroundColor(Theme.clay)

                Text("No. \(cardNumber)")
                    .font(Theme.monoFont(size: 10))
                    .foregroundColor(Theme.clay.opacity(0.6))
            }

            Spacer()

            MenuStamp(text: "Fresh", color: Theme.forest, rotation: 12)
        }
    }

    // MARK: - Card Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Title
            Text(title)
                .font(Theme.displayFont(size: 24))
                .foregroundColor(Theme.ink)
                .padding(.bottom, 8)

            // Description
            Text(description)
                .font(Theme.bodyFont(size: 15))
                .foregroundColor(Theme.subtleText)
                .lineSpacing(4)
                .padding(.bottom, 12)

            // Time badge and tags in one row
            HStack(spacing: 8) {
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 12, weight: .medium))
                    Text("\(minutes) min")
                        .font(Theme.labelFont(size: 13))
                }
                .foregroundColor(Theme.forest)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Theme.sage.opacity(0.25))
                )

                MenuTag(text: energyLabel, color: Theme.mustard)
                MenuTag(text: contextLabel, color: Theme.terracotta)
            }
        }
    }

    // MARK: - Card Actions

    private var cardActions: some View {
        VStack(spacing: 12) {
            // Primary action
            Button {
                haptic(.medium)
                onSelect()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                    Text("I'll have this")
                }
            }
            .buttonStyle(MenuPrimaryButtonStyle(color: Theme.terracotta))
            .accessibilityIdentifier("selectButton")

            // Secondary actions - all same height
            HStack(spacing: 8) {
                Button {
                    haptic()
                    onRefresh()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.trianglehead.2.clockwise")
                            .font(.system(size: 13))
                        Text("Another")
                    }
                    .frame(maxWidth: .infinity, minHeight: 40)
                }
                .buttonStyle(AlignedSecondaryButtonStyle(color: Theme.forest))
                .accessibilityIdentifier("refreshButton")

                Button {
                    haptic()
                    onAskAI()
                } label: {
                    Image(systemName: "sparkles")
                        .font(.system(size: 16))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(AlignedIconButtonStyle(color: Theme.mustard))
                .accessibilityIdentifier("askAIButton")
                .accessibilityLabel("Ask AI")

                Button {
                    haptic()
                    onFavorite()
                } label: {
                    Image(systemName: isFavorited ? "heart.fill" : "heart")
                        .font(.system(size: 16))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(AlignedIconButtonStyle(color: Theme.terracotta))
                .accessibilityIdentifier("favoriteButton")
                .accessibilityLabel("Favorite")

                Button {
                    haptic()
                    onDismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(AlignedIconButtonStyle(color: Theme.clay))
                .accessibilityIdentifier("dismissButton")
                .accessibilityLabel("Dismiss")
            }
        }
    }

    // MARK: - Helpers

    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        guard Theme.hapticFeedbackEnabled else { return }
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

// MARK: - Preview

#Preview("Menu Card") {
    ScrollView {
        MenuCardView(
            title: "Stretch + Sip Water",
            description: "Reset your shoulders, take three slow breaths, and hydrate. A simple ritual to reset your body and mind.",
            minutes: 15,
            energyLabel: "Steady",
            contextLabel: "Just me"
        )
        .padding(20)
    }
    .background(PaperTexture())
}
