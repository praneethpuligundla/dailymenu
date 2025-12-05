import Foundation

/// Parses AI-generated activity responses into structured data
enum AIActivityParser {

    /// Parsed activity from AI response
    struct ParsedActivity: Codable {
        let title: String
        let description: String
        let expectedMinutes: Int
        let energy: String
        let context: String
        let category: String
        let tags: [String]

        /// Whether this activity should be submitted to community
        var submitToCommunity: Bool = false

        enum CodingKeys: String, CodingKey {
            case title, description, expectedMinutes, energy, context, category, tags
        }
    }

    /// Parse JSON response from AI
    static func parse(_ text: String) -> ParsedActivity? {
        // Try to extract JSON from the response
        let jsonString = extractJSON(from: text)

        guard let data = jsonString.data(using: .utf8) else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(ParsedActivity.self, from: data)
        } catch {
            print("Failed to parse AI response: \(error)")
            return tryFallbackParse(text)
        }
    }

    /// Extract JSON object from text that might have extra content
    private static func extractJSON(from text: String) -> String {
        // Find JSON object boundaries
        guard let startIndex = text.firstIndex(of: "{"),
              let endIndex = text.lastIndex(of: "}") else {
            return text
        }

        return String(text[startIndex...endIndex])
    }

    /// Fallback parser for non-JSON responses
    private static func tryFallbackParse(_ text: String) -> ParsedActivity? {
        // Try to parse markdown format: **Activity:** Name
        var title: String?
        var description: String?
        var minutes = 15

        let lines = text.components(separatedBy: "\n")
        for line in lines {
            let cleaned = line.trimmingCharacters(in: .whitespaces)

            if cleaned.lowercased().contains("activity:") {
                title = cleaned
                    .replacingOccurrences(of: "**Activity:**", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "Activity:", with: "", options: .caseInsensitive)
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: "**", with: "")
            }

            if cleaned.lowercased().contains("description:") {
                description = cleaned
                    .replacingOccurrences(of: "**Description:**", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "Description:", with: "", options: .caseInsensitive)
                    .trimmingCharacters(in: .whitespaces)
                    .replacingOccurrences(of: "**", with: "")
            }

            if cleaned.lowercased().contains("time:") {
                let timeStr = cleaned
                    .replacingOccurrences(of: "**Time:**", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "Time:", with: "", options: .caseInsensitive)
                    .trimmingCharacters(in: .whitespaces)
                // Extract number
                let numbers = timeStr.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if let num = Int(numbers) {
                    minutes = num
                }
            }
        }

        guard let activityTitle = title, !activityTitle.isEmpty else {
            return nil
        }

        return ParsedActivity(
            title: activityTitle,
            description: description ?? "A moment of joy awaits.",
            expectedMinutes: minutes,
            energy: "okay",
            context: "solo",
            category: minutes <= 5 ? "starter" : (minutes <= 20 ? "main" : "dessert"),
            tags: ["ai-generated", "custom"]
        )
    }

    /// Validate parsed activity
    static func isValid(_ activity: ParsedActivity) -> Bool {
        !activity.title.isEmpty &&
        !activity.description.isEmpty &&
        activity.expectedMinutes > 0 &&
        activity.expectedMinutes <= 180
    }
}

// MARK: - Shared Storage for Extension

/// Manages shared data between main app and extensions via App Group
enum SharedActivityStorage {
    static let appGroupIdentifier = "group.com.dailymenu.shared"
    static let pendingActivitiesKey = "pendingActivities"
    static let communitySubmissionsKey = "communitySubmissions"

    private static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    /// Save activity from Share Extension for main app to import
    static func savePendingActivity(_ activity: AIActivityParser.ParsedActivity) {
        var pending = getPendingActivities()
        pending.append(activity)

        if let data = try? JSONEncoder().encode(pending) {
            sharedDefaults?.set(data, forKey: pendingActivitiesKey)
        }
    }

    /// Get pending activities to import
    static func getPendingActivities() -> [AIActivityParser.ParsedActivity] {
        guard let data = sharedDefaults?.data(forKey: pendingActivitiesKey),
              let activities = try? JSONDecoder().decode([AIActivityParser.ParsedActivity].self, from: data) else {
            return []
        }
        return activities
    }

    /// Clear pending activities after import
    static func clearPendingActivities() {
        sharedDefaults?.removeObject(forKey: pendingActivitiesKey)
    }

    /// Queue activity for community submission
    static func queueForCommunity(_ activity: AIActivityParser.ParsedActivity) {
        var queue = getCommunityQueue()
        var activityWithFlag = activity
        activityWithFlag.submitToCommunity = true
        queue.append(activityWithFlag)

        if let data = try? JSONEncoder().encode(queue) {
            sharedDefaults?.set(data, forKey: communitySubmissionsKey)
        }
    }

    /// Get activities queued for community submission
    static func getCommunityQueue() -> [AIActivityParser.ParsedActivity] {
        guard let data = sharedDefaults?.data(forKey: communitySubmissionsKey),
              let activities = try? JSONDecoder().decode([AIActivityParser.ParsedActivity].self, from: data) else {
            return []
        }
        return activities
    }

    /// Clear community queue after successful submission
    static func clearCommunityQueue() {
        sharedDefaults?.removeObject(forKey: communitySubmissionsKey)
    }
}
