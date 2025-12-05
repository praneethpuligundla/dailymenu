import SwiftUI

// MARK: - Filter Dropdown Pill

struct FilterDropdownPill: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .medium))
            Text(text)
                .font(Theme.labelFont(size: 14))
            Image(systemName: "chevron.down")
                .font(.system(size: 9, weight: .bold))
                .opacity(0.6)
        }
        .foregroundColor(color)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(color.opacity(0.25), lineWidth: 1)
                )
        )
    }
}

// MARK: - Filter Pill (Legacy)

struct FilterPill: View {
    let icon: String
    let text: String
    let color: Color
    var isActive: Bool = false

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .semibold))
            Text(text)
                .font(Theme.labelFont(size: 13))
        }
        .foregroundColor(isActive ? color : Theme.clay)
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(isActive ? color.opacity(0.12) : Theme.warmWhite)
                .overlay(
                    Capsule()
                        .stroke(color.opacity(isActive ? 0.3 : 0.15), lineWidth: 1)
                )
        )
    }
}

// MARK: - Filter Row

struct FilterRow<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(Theme.labelFont(size: 13))
                .foregroundColor(Theme.clay)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    content
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let text: String
    var subtitle: String? = nil
    var icon: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 13, weight: .medium))
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(text)
                        .font(Theme.labelFont(size: 15))
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.system(size: 11, weight: .regular, design: .rounded))
                            .opacity(0.7)
                    }
                }
            }
        }
        .buttonStyle(MenuChipStyle(isSelected: isSelected))
    }
}

// MARK: - Preview

#Preview("Filter Components") {
    VStack(spacing: 30) {
        // Pills
        HStack(spacing: 12) {
            FilterPill(icon: "clock", text: "15 min", color: Theme.terracotta, isActive: true)
            FilterPill(icon: "bolt.fill", text: "Steady", color: Theme.mustard, isActive: true)
            FilterPill(icon: "person", text: "Solo", color: Theme.forest, isActive: false)
        }

        // Filter Row
        FilterRow(title: "Time") {
            FilterChip(text: "5 min", subtitle: "Quick bite", isSelected: false) {}
            FilterChip(text: "15 min", subtitle: "A nice break", isSelected: true) {}
            FilterChip(text: "30+", subtitle: "Take your time", isSelected: false) {}
        }

        // Filter Row with icons
        FilterRow(title: "Energy") {
            FilterChip(text: "Cozy", icon: "moon.stars", isSelected: false) {}
            FilterChip(text: "Steady", icon: "sun.haze", isSelected: true) {}
            FilterChip(text: "Buzzing", icon: "bolt.fill", isSelected: false) {}
        }
    }
    .padding(.vertical, 40)
    .background(PaperTexture())
}
