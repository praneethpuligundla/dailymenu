import Foundation

/// Audits copy for tone compliance (warm, non-judgmental, no pressure)
struct CopyToneChecker {
    // MARK: - Forbidden Patterns

    /// Words/phrases that violate the warm, pressure-free tone
    static let forbiddenPatterns: [String] = [
        // Streak/gamification language
        "streak", "streaks", "daily streak", "maintain",
        "keep it up", "don't break", "chain",

        // Leaderboard/competition language
        "leaderboard", "rank", "ranking", "top users",
        "compete", "winner", "beat", "score",

        // Productivity pressure
        "must", "should", "have to", "need to",
        "productive", "productivity", "optimize",
        "maximize", "efficiency",

        // Guilt/judgment language
        "failed", "failure", "missed", "didn't do",
        "lazy", "slacking", "behind", "catch up",

        // Achievement pressure
        "goal", "target", "milestone", "achievement unlocked",
        "level up", "badge", "reward"
    ]

    /// Preferred alternatives for common patterns
    static let preferredAlternatives: [String: String] = [
        "goal": "intention",
        "must": "could",
        "should": "might",
        "productive": "engaged",
        "achievement": "moment",
        "failed": "chose differently"
    ]

    // MARK: - Audit Methods

    /// Audit a string for tone violations
    static func audit(_ text: String) -> ToneAuditResult {
        var violations: [ToneViolation] = []
        let lowercased = text.lowercased()

        for pattern in forbiddenPatterns {
            if lowercased.contains(pattern) {
                let alternative = preferredAlternatives[pattern]
                violations.append(ToneViolation(
                    pattern: pattern,
                    context: text,
                    suggestion: alternative
                ))
            }
        }

        return ToneAuditResult(text: text, violations: violations)
    }

    /// Audit all copy in the Copy enum
    static func auditAllCopy() -> [ToneAuditResult] {
        var results: [ToneAuditResult] = []

        // Use reflection to get all static strings from Copy enum
        let mirror = Mirror(reflecting: Copy.self)
        for child in mirror.children {
            if let value = child.value as? String {
                let result = audit(value)
                if !result.isClean {
                    results.append(result)
                }
            }
        }

        return results
    }

    /// Check if text follows warm tone guidelines
    static func isWarmTone(_ text: String) -> Bool {
        let result = audit(text)
        return result.isClean
    }
}

// MARK: - Audit Result Models

struct ToneAuditResult {
    let text: String
    let violations: [ToneViolation]

    var isClean: Bool {
        violations.isEmpty
    }

    var summary: String {
        if isClean {
            return "✓ Clean (warm, non-judgmental tone)"
        } else {
            return "✗ \(violations.count) violation(s) found"
        }
    }

    var detailedReport: String {
        var report = "Text: \"\(text)\"\n"
        report += summary + "\n"

        if !violations.isEmpty {
            report += "\nViolations:\n"
            for violation in violations {
                report += "  - Pattern: \"\(violation.pattern)\"\n"
                if let suggestion = violation.suggestion {
                    report += "    Suggestion: Use \"\(suggestion)\" instead\n"
                }
            }
        }

        return report
    }
}

struct ToneViolation {
    let pattern: String
    let context: String
    let suggestion: String?
}
