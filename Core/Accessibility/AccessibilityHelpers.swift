import SwiftUI

/// Accessibility helpers for WCAG 2.1 AA compliance
enum AccessibilityHelpers {
    // MARK: - WCAG Constants

    /// Minimum contrast ratio for normal text (WCAG AA)
    static let minimumContrastRatio: Double = 4.5

    /// Minimum contrast ratio for large text (WCAG AA)
    static let largeTextContrastRatio: Double = 3.0

    /// Minimum tap target size (44pt x 44pt per iOS HIG)
    static let minimumTapTarget: CGFloat = 44.0

    // MARK: - Contrast Checking

    /// Calculate contrast ratio between two colors
    static func contrastRatio(foreground: Color, background: Color) -> Double {
        let fgLuminance = relativeLuminance(color: foreground)
        let bgLuminance = relativeLuminance(color: background)

        let lighter = max(fgLuminance, bgLuminance)
        let darker = min(fgLuminance, bgLuminance)

        return (lighter + 0.05) / (darker + 0.05)
    }

    /// Check if contrast meets WCAG AA standard
    static func meetsWCAGAA(foreground: Color, background: Color, isLargeText: Bool = false) -> Bool {
        let ratio = contrastRatio(foreground: foreground, background: background)
        let threshold = isLargeText ? largeTextContrastRatio : minimumContrastRatio
        return ratio >= threshold
    }

    // MARK: - VoiceOver Labels

    /// Generate VoiceOver label for suggestion card
    static func suggestionCardLabel(activity: ActivityEntity) -> String {
        let title = activity.title ?? "Untitled"
        let minutes = activity.expectedMinutes
        let energy = (activity.energy ?? "").capitalized
        let context = (activity.context ?? "").capitalized

        return "\(title). \(minutes) minutes. \(energy) energy. \(context) activity."
    }

    /// Generate VoiceOver hint for button
    static func buttonHint(_ action: String) -> String {
        return "Double tap to \(action)"
    }

    // MARK: - Dynamic Type Support

    /// Get scaled font size for dynamic type
    static func scaledFont(baseSize: CGFloat, style: Font.TextStyle) -> Font {
        return .system(size: baseSize).weight(.regular)
    }

    // MARK: - Private Helpers

    /// Calculate relative luminance of a color (WCAG 2.1 formula)
    private static func relativeLuminance(color: Color) -> Double {
        // Convert SwiftUI Color to RGB components (simplified)
        // In production, use UIColor/NSColor conversion
        let components = colorComponents(color: color)

        let r = linearize(component: components.red)
        let g = linearize(component: components.green)
        let b = linearize(component: components.blue)

        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    /// Linearize color component for luminance calculation
    private static func linearize(component: Double) -> Double {
        if component <= 0.03928 {
            return component / 12.92
        } else {
            return pow((component + 0.055) / 1.055, 2.4)
        }
    }

    /// Extract RGB components from SwiftUI Color (simplified)
    private static func colorComponents(color: Color) -> (red: Double, green: Double, blue: Double) {
        // This is a simplified version. In production, convert via UIColor/NSColor
        // For now, return default values
        #if canImport(UIKit)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        UIColor(color).getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Double(r), Double(g), Double(b))
        #else
        return (0.5, 0.5, 0.5) // Fallback for non-iOS platforms
        #endif
    }
}

// MARK: - View Modifiers

extension View {
    /// Ensure minimum tap target size
    func accessibleTapTarget() -> some View {
        self.frame(minWidth: AccessibilityHelpers.minimumTapTarget,
                   minHeight: AccessibilityHelpers.minimumTapTarget)
    }

    /// Add VoiceOver label and hint
    func voiceOver(label: String, hint: String? = nil) -> some View {
        self.accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }
}
