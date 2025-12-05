import SwiftUI

// MARK: - Dotted Divider

struct DottedDivider: View {
    var color: Color = Theme.clay.opacity(0.3)

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let dashWidth: CGFloat = 4
                let dashSpacing: CGFloat = 6
                var x: CGFloat = 0
                while x < geometry.size.width {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: min(x + dashWidth, geometry.size.width), y: 0))
                    x += dashWidth + dashSpacing
                }
            }
            .stroke(color, lineWidth: 1)
        }
        .frame(height: 1)
    }
}

// MARK: - Corner Flourish

struct CornerFlourish: View {
    var color: Color = Theme.clay.opacity(0.2)

    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 0, y: 20))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 20, y: 0))
        }
        .stroke(color, lineWidth: 1)
        .frame(width: 20, height: 20)
    }
}

// MARK: - Menu Tag

struct MenuTag: View {
    let text: String
    let color: Color

    var body: some View {
        Text(text)
            .font(Theme.monoFont(size: 11))
            .tracking(0.5)
            .foregroundColor(color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(color.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(color.opacity(0.2), lineWidth: 1)
                    )
            )
    }
}

// MARK: - Decorative Card Background

struct DecorativeCardBackground: View {
    var cornerRadius: CGFloat = Theme.cardCornerRadius

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(Theme.warmWhite)

            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Theme.clay.opacity(0.15), lineWidth: 1)

            VStack {
                HStack {
                    CornerFlourish()
                    Spacer()
                    CornerFlourish()
                        .scaleEffect(x: -1, y: 1)
                }
                Spacer()
                HStack {
                    CornerFlourish()
                        .scaleEffect(x: 1, y: -1)
                    Spacer()
                    CornerFlourish()
                        .scaleEffect(x: -1, y: -1)
                }
            }
            .padding(12)
        }
        .allowsHitTesting(false)
    }
}

// MARK: - Preview

#Preview("Decorations") {
    VStack(spacing: 40) {
        DottedDivider()
            .padding(.horizontal, 40)

        HStack {
            CornerFlourish()
            Spacer()
            CornerFlourish()
                .scaleEffect(x: -1, y: 1)
        }
        .padding(.horizontal, 40)

        HStack(spacing: 10) {
            MenuTag(text: "Cozy", color: Theme.mustard)
            MenuTag(text: "Solo", color: Theme.terracotta)
            MenuTag(text: "Starter", color: Theme.forest)
        }

        RoundedRectangle(cornerRadius: 24)
            .fill(Color.clear)
            .frame(height: 200)
            .background(DecorativeCardBackground())
            .padding(.horizontal, 20)
    }
    .padding(.vertical, 40)
    .background(PaperTexture())
}
