import XCTest
import SwiftUI
import CoreData
@testable import DailyMenu

/// Tests for WCAG 2.1 AA compliance and accessibility
final class AccessibilityTests: XCTestCase {

    // MARK: - Contrast Ratio Tests

    func testThemeTextOnBackgroundContrastRatio() {
        let ratio = AccessibilityHelpers.contrastRatio(
            foreground: Theme.text,
            background: Theme.background
        )

        // Must meet WCAG AA (4.5:1 minimum)
        XCTAssertGreaterThanOrEqual(
            ratio,
            AccessibilityHelpers.minimumContrastRatio,
            "Text on background contrast ratio (\(String(format: "%.2f", ratio)):1) does not meet WCAG AA"
        )
    }

    func testThemeSubtleTextOnBackgroundContrastRatio() {
        let ratio = AccessibilityHelpers.contrastRatio(
            foreground: Theme.subtleText,
            background: Theme.background
        )

        // Must meet WCAG AA (4.5:1 minimum)
        XCTAssertGreaterThanOrEqual(
            ratio,
            AccessibilityHelpers.minimumContrastRatio,
            "Subtle text on background contrast ratio (\(String(format: "%.2f", ratio)):1) does not meet WCAG AA"
        )
    }

    func testThemeAccentOnBackgroundContrastRatio() {
        let ratio = AccessibilityHelpers.contrastRatio(
            foreground: Theme.accent,
            background: Theme.background
        )

        // Accent color should also meet WCAG AA
        XCTAssertGreaterThanOrEqual(
            ratio,
            AccessibilityHelpers.minimumContrastRatio,
            "Accent on background contrast ratio (\(String(format: "%.2f", ratio)):1) does not meet WCAG AA"
        )
    }

    func testWCAGAAHelper() {
        // Test with known good contrast
        let goodContrast = AccessibilityHelpers.meetsWCAGAA(
            foreground: .black,
            background: .white,
            isLargeText: false
        )
        XCTAssertTrue(goodContrast, "Black on white should meet WCAG AA")

        // Test with large text threshold
        let largeTextOK = AccessibilityHelpers.meetsWCAGAA(
            foreground: .black,
            background: .white,
            isLargeText: true
        )
        XCTAssertTrue(largeTextOK, "Large text should have lower contrast requirement")
    }

    // MARK: - Tap Target Tests

    func testMinimumTapTargetSize() {
        // Verify minimum tap target constant meets iOS HIG
        XCTAssertEqual(
            AccessibilityHelpers.minimumTapTarget,
            44.0,
            "Minimum tap target should be 44pt per iOS HIG"
        )

        XCTAssertEqual(
            Theme.minTapTarget,
            44.0,
            "Theme minimum tap target should match accessibility guideline"
        )
    }

    // MARK: - VoiceOver Label Tests

    func testSuggestionCardVoiceOverLabel() {
        // Create test activity
        let activity = createTestActivity()

        let label = AccessibilityHelpers.suggestionCardLabel(activity: activity)

        // Label should include key information
        XCTAssertTrue(label.contains(activity.title ?? ""), "Label should include activity title")
        XCTAssertTrue(label.contains("\(activity.expectedMinutes)"), "Label should include duration")
        XCTAssertTrue(label.contains((activity.energy ?? "").capitalized), "Label should include energy level")
        XCTAssertTrue(label.contains((activity.context ?? "").capitalized), "Label should include context")
    }

    func testButtonHint() {
        let hint = AccessibilityHelpers.buttonHint("save activity")
        XCTAssertEqual(hint, "Double tap to save activity")
    }

    // MARK: - Copy Tone Tests

    func testCopyContainsNoStreakLanguage() {
        let result = CopyToneChecker.audit(Copy.activityCompleted)
        XCTAssertTrue(result.isClean, "Activity completed copy should not contain streak language")
    }

    func testCopyContainsNoLeaderboardLanguage() {
        let allCopyResults = CopyToneChecker.auditAllCopy()

        if !allCopyResults.isEmpty {
            XCTFail("Found tone violations in Copy:\n" + allCopyResults.map { $0.detailedReport }.joined(separator: "\n\n"))
        }
    }

    func testCopyToneChecker_DetectsForbiddenPatterns() {
        let badExamples = [
            "Keep your streak going!",
            "You're on the leaderboard!",
            "You must complete this goal",
            "Don't break your chain"
        ]

        for example in badExamples {
            let result = CopyToneChecker.audit(example)
            XCTAssertFalse(result.isClean, "\"\(example)\" should be flagged as tone violation")
            XCTAssertGreaterThan(result.violations.count, 0)
        }
    }

    func testCopyToneChecker_AllowsWarmLanguage() {
        let goodExamples = [
            Copy.activityCompleted,      // "Nice, that counts"
            Copy.tinyJoysAddUp,           // "Tiny joys add up"
            Copy.permissionToRest,        // "You have permission to rest"
            Copy.noWrongChoices          // "There are no wrong choices here"
        ]

        for example in goodExamples {
            let result = CopyToneChecker.audit(example)
            XCTAssertTrue(result.isClean, "\"\(example)\" should pass tone check")
        }
    }

    // MARK: - Dynamic Type Tests

    func testScaledFontCreation() {
        let font = AccessibilityHelpers.scaledFont(baseSize: 16, style: .body)
        XCTAssertNotNil(font, "Scaled font should be created")
    }

    // MARK: - Full Copy Audit Test

    func testFullCopyAudit() {
        // Audit all strings in Copy enum
        let violations = CopyToneChecker.auditAllCopy()

        // Generate detailed report
        if !violations.isEmpty {
            var report = "=== COPY TONE AUDIT REPORT ===\n\n"
            report += "Found \(violations.count) violation(s):\n\n"

            for (index, violation) in violations.enumerated() {
                report += "[\(index + 1)] \(violation.detailedReport)\n"
            }

            print(report)
            XCTFail("Copy tone audit failed. See console for detailed report.")
        }
    }

    // MARK: - Accessibility Copy Tests

    func testAccessibilityLabelsExist() {
        // Verify accessibility-specific copy exists
        XCTAssertFalse(Copy.closeButton.isEmpty)
        XCTAssertFalse(Copy.backButton.isEmpty)
        XCTAssertFalse(Copy.favoriteButton.isEmpty)
        XCTAssertFalse(Copy.unfavoriteButton.isEmpty)
        XCTAssertFalse(Copy.hideActivityButton.isEmpty)
        XCTAssertFalse(Copy.expandDetailsButton.isEmpty)
        XCTAssertFalse(Copy.collapseDetailsButton.isEmpty)
    }

    // MARK: - Helper Methods

    private func createTestActivity() -> ActivityEntity {
        // Create in-memory persistent container for testing
        let container = NSPersistentContainer(name: "DailyMenu")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load test store: \(error)")
            }
        }

        let context = container.viewContext

        let activity = ActivityEntity(context: context)
        activity.id = UUID()
        activity.title = "Test Activity"
        activity.descriptionText = "Test description"
        activity.expectedMinutes = 10
        activity.category = "starter"
        activity.energy = "medium"
        activity.context = "solo"
        activity.repeatable = true
        activity.source = "seed"
        activity.moderationStatus = "approved"

        return activity
    }
}
