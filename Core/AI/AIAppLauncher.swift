import Foundation
import UIKit

/// Launches user's AI apps (ChatGPT, Claude, Gemini) with activity suggestion prompts
enum AIAppLauncher {

    enum AIApp: String, CaseIterable, Identifiable {
        case chatgpt = "ChatGPT"
        case claude = "Claude"
        case gemini = "Gemini"

        var id: String { rawValue }

        var icon: String {
            switch self {
            case .chatgpt: return "bubble.left.and.bubble.right"
            case .claude: return "sparkles"
            case .gemini: return "star"
            }
        }

        /// URL scheme to check if app is installed
        var urlScheme: String {
            switch self {
            case .chatgpt: return "chatgpt://"
            case .claude: return "claude://"
            case .gemini: return "googlegemini://"
            }
        }

        /// App Store URL if not installed
        var appStoreURL: URL {
            switch self {
            case .chatgpt: return URL(string: "https://apps.apple.com/app/chatgpt/id6448311069")!
            case .claude: return URL(string: "https://apps.apple.com/app/claude/id6473753684")!
            case .gemini: return URL(string: "https://apps.apple.com/app/google-gemini/id6477141669")!
            }
        }
    }

    /// Check if an AI app is installed
    static func isInstalled(_ app: AIApp) -> Bool {
        guard let url = URL(string: app.urlScheme) else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    /// Get list of installed AI apps
    static func installedApps() -> [AIApp] {
        AIApp.allCases.filter { isInstalled($0) }
    }

    /// Generate a prompt for activity suggestion with structured JSON output
    static func generatePrompt(time: Int, energy: String, context: String) -> String {
        """
        Suggest ONE simple, joyful activity I can do right now.

        My preferences:
        - Time available: \(time) minutes
        - Energy level: \(energy) (low=restful, okay=balanced, upForSomething=active)
        - Context: \(context) (solo or withSomeone)

        Requirements:
        - Keep it simple and achievable
        - Make it feel like a treat, not a task
        - No screens unless necessary
        - Focus on tiny joys and self-care

        IMPORTANT: Respond ONLY with valid JSON in this exact format (no markdown, no explanation):
        {
          "title": "Short activity name (3-6 words)",
          "description": "Why this activity is nice and how to do it (1-2 sentences)",
          "expectedMinutes": \(time),
          "energy": "\(mapEnergyToValue(energy))",
          "context": "\(mapContextToValue(context))",
          "category": "starter|main|dessert",
          "tags": ["tag1", "tag2", "tag3"]
        }

        Category guide: starter=quick breaks, main=moderate activities, dessert=longer indulgences
        """
    }

    /// Map display energy to internal value
    private static func mapEnergyToValue(_ display: String) -> String {
        switch display.lowercased() {
        case "cozy": return "low"
        case "steady": return "okay"
        case "buzzing": return "upForSomething"
        default: return "okay"
        }
    }

    /// Map display context to internal value
    private static func mapContextToValue(_ display: String) -> String {
        switch display.lowercased() {
        case "just me": return "solo"
        case "with company": return "withSomeone"
        default: return "solo"
        }
    }

    /// Open AI app with prompt (copies to clipboard for pasting)
    @MainActor
    static func openWithPrompt(app: AIApp, time: Int, energy: String, context: String) {
        let prompt = generatePrompt(time: time, energy: energy, context: context)

        // Copy prompt to clipboard
        UIPasteboard.general.string = prompt

        // Try to open the app
        if let url = URL(string: app.urlScheme) {
            UIApplication.shared.open(url) { success in
                if !success {
                    // App not installed, open App Store
                    UIApplication.shared.open(app.appStoreURL)
                }
            }
        }
    }

    /// Open AI app via universal link (better for ChatGPT)
    @MainActor
    static func openChatGPTWithPrompt(time: Int, energy: String, context: String) {
        let prompt = generatePrompt(time: time, energy: energy, context: context)

        // URL encode the prompt
        let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        // ChatGPT supports direct prompt via URL
        if let url = URL(string: "https://chat.openai.com/?q=\(encodedPrompt)") {
            UIApplication.shared.open(url)
        }
    }
}
