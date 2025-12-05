import SwiftUI

// MARK: - The Paper Menu Theme
// A warm, handcrafted aesthetic inspired by vintage letterpress menus
// Rich earthy tones, tactile textures, typography with soul

enum Theme {
    // MARK: - Color Palette (Artisanal Warmth)

    // Paper & Canvas
    static let cream = Color(red: 0.98, green: 0.96, blue: 0.91)        // Aged paper
    static let warmWhite = Color(red: 0.99, green: 0.98, blue: 0.96)    // Fresh linen
    static let parchment = Color(red: 0.95, green: 0.91, blue: 0.84)    // Antique paper

    // Primary Palette
    static let terracotta = Color(red: 0.80, green: 0.42, blue: 0.32)   // Warm rust-orange
    static let forest = Color(red: 0.22, green: 0.38, blue: 0.34)       // Deep sage green
    static let mustard = Color(red: 0.85, green: 0.68, blue: 0.32)      // Golden ochre
    static let ink = Color(red: 0.15, green: 0.13, blue: 0.12)          // Rich charcoal

    // Supporting Tones
    static let clay = Color(red: 0.72, green: 0.58, blue: 0.48)         // Warm neutral
    static let sage = Color(red: 0.62, green: 0.72, blue: 0.64)         // Soft green
    static let blush = Color(red: 0.94, green: 0.84, blue: 0.78)        // Warm pink-beige

    // Legacy compatibility
    static let background = cream
    static let surface = warmWhite
    static let accent = terracotta
    static let accentSoft = blush
    static let text = ink
    static let subtleText = Color(red: 0.45, green: 0.42, blue: 0.38)
    static let gentleGreen = forest
    static let warmWarning = mustard

    // MARK: - Layout & Spacing

    static let cornerRadius: CGFloat = 16
    static let chipCornerRadius: CGFloat = 20
    static let cardCornerRadius: CGFloat = 24
    static let padding: CGFloat = 16
    static let paddingSmall: CGFloat = 10
    static let paddingLarge: CGFloat = 28
    static let minTapTarget: CGFloat = 48

    // MARK: - Typography

    static func displayFont(size: CGFloat) -> Font {
        .system(size: size, weight: .bold, design: .serif)
    }

    static func titleFont(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func bodyFont(size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .rounded)
    }

    static func labelFont(size: CGFloat = 14) -> Font {
        .system(size: size, weight: .medium, design: .rounded)
    }

    static func monoFont(size: CGFloat = 13) -> Font {
        .system(size: size, weight: .medium, design: .monospaced)
    }

    // Legacy
    static func headerFont() -> Font { titleFont(size: 20) }
    static func chipFont() -> Font { labelFont(size: 14) }
    static func captionFont() -> Font { labelFont(size: 12) }
    static func largeTitle() -> Font { displayFont(size: 32) }

    // MARK: - Accessibility

    static let minimumContrastRatio: Double = 4.5
    static let hapticFeedbackEnabled = true
}

// MARK: - Paper Texture Background

struct PaperTexture: View {
    var body: some View {
        ZStack {
            Theme.cream

            // Warm gradient overlay for depth
            LinearGradient(
                colors: [
                    Theme.parchment.opacity(0.4),
                    Theme.cream,
                    Theme.blush.opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Decorative Stamp Element

struct MenuStamp: View {
    let text: String
    var color: Color = Theme.terracotta
    var rotation: Double = -8

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 11, weight: .black, design: .rounded))
            .tracking(2)
            .foregroundColor(color)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(color, lineWidth: 2)
            )
            .rotationEffect(.degrees(rotation))
    }
}

// MARK: - Menu Chip Style

struct MenuChipStyle: ButtonStyle {
    let isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.labelFont(size: 15))
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(
                ZStack {
                    if isSelected {
                        RoundedRectangle(cornerRadius: Theme.chipCornerRadius)
                            .fill(Theme.terracotta)
                    } else {
                        RoundedRectangle(cornerRadius: Theme.chipCornerRadius)
                            .fill(Theme.warmWhite)
                        RoundedRectangle(cornerRadius: Theme.chipCornerRadius)
                            .stroke(Theme.clay.opacity(0.4), lineWidth: 1.5)
                    }
                }
            )
            .foregroundColor(isSelected ? Theme.warmWhite : Theme.ink)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Menu Primary Button Style

struct MenuPrimaryButtonStyle: ButtonStyle {
    var color: Color = Theme.terracotta

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.labelFont(size: 15))
            .foregroundColor(Theme.warmWhite)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color)
            )
            .shadow(color: color.opacity(0.25), radius: 6, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Menu Secondary Button Style

struct MenuSecondaryButtonStyle: ButtonStyle {
    var color: Color = Theme.forest

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.labelFont(size: 14))
            .foregroundColor(color)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(color.opacity(0.4), lineWidth: 1.5)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(color.opacity(0.06))
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Icon Button Style

struct MenuIconButtonStyle: ButtonStyle {
    var color: Color = Theme.clay

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(Theme.warmWhite)
                    .overlay(
                        Circle()
                            .stroke(color.opacity(0.25), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Card Secondary Button Style (for aligned rows)

struct CardSecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.labelFont(size: 14))
            .foregroundColor(Theme.forest)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Theme.forest.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Theme.forest.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Card Icon Button Style (square, for aligned rows)

struct CardIconButtonStyle: ButtonStyle {
    var color: Color = Theme.clay

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .frame(width: 44, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

// MARK: - Aligned Secondary Button Style

struct AlignedSecondaryButtonStyle: ButtonStyle {
    var color: Color = Theme.forest

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(Theme.labelFont(size: 14))
            .foregroundColor(color)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Aligned Icon Button Style

struct AlignedIconButtonStyle: ButtonStyle {
    var color: Color = Theme.clay

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(color)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(color.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
