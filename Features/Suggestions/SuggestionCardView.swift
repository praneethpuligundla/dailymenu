import SwiftUI

struct SuggestionCardView: View {
    let activity: ActivityEntity
    @State private var isExpanded = false
    let onSave: () -> Void
    let onHide: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.padding) {
            // Title & time
            HStack {
                Text(activity.title)
                    .font(Theme.headerFont())
                Spacer()
                Text("\(activity.expectedMinutes) min")
                    .font(Theme.captionFont())
                    .foregroundColor(Theme.subtleText)
            }

            Text(activity.descriptionText)
                .font(Theme.bodyFont())
                .foregroundColor(Theme.subtleText)

            if isExpanded {
                // Tags
                if let tagsJSON = activity.tagsJSON,
                   let data = tagsJSON.data(using: .utf8),
                   let tags = try? JSONDecoder().decode([String].self, from: data) {
                    HStack {
                        ForEach(tags, id: \.self) { tag in
                            Text("#\(tag)")
                                .font(Theme.chipFont())
                                .padding(.horizontal, Theme.paddingSmall)
                                .padding(.vertical, 4)
                                .background(Theme.accentSoft)
                                .cornerRadius(Theme.chipCornerRadius)
                        }
                    }
                }
            }

            // Actions
            HStack(spacing: Theme.paddingSmall) {
                Button(Copy.doThis) { onDone() }
                    .buttonStyle(.borderedProminent)
                    .accessibleTapTarget()
                    .voiceOver(
                        label: Copy.iDidThis,
                        hint: AccessibilityHelpers.buttonHint("mark this activity as done")
                    )
                Spacer()
                Button("Save") { onSave() }
                    .accessibleTapTarget()
                    .voiceOver(
                        label: Copy.favoriteButton,
                        hint: AccessibilityHelpers.buttonHint("save to favorites")
                    )
                Button("Hide") { onHide() }
                    .accessibleTapTarget()
                    .voiceOver(
                        label: Copy.hideActivityButton,
                        hint: AccessibilityHelpers.buttonHint("hide this activity")
                    )
                Button(isExpanded ? "Less" : "More") { isExpanded.toggle() }
                    .accessibleTapTarget()
                    .voiceOver(
                        label: isExpanded ? Copy.collapseDetailsButton : Copy.expandDetailsButton,
                        hint: AccessibilityHelpers.buttonHint(isExpanded ? "hide details" : "show details")
                    )
            }
            .font(Theme.chipFont())
        }
        .padding(Theme.padding)
        .background(Theme.surface)
        .cornerRadius(Theme.cornerRadius)
        .shadow(radius: 2)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(AccessibilityHelpers.suggestionCardLabel(activity: activity))
    }
}
