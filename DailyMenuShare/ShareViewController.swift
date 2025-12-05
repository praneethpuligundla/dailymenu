import UIKit
import UniformTypeIdentifiers

/// Share Extension view controller for importing AI-generated activities
class ShareViewController: UIViewController {

    // MARK: - UI Elements

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.96, blue: 0.94, alpha: 1.0) // Theme.cream
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Import to Daily Menu"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0.2, green: 0.18, blue: 0.16, alpha: 1.0) // Theme.ink
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = UIColor(red: 0.2, green: 0.18, blue: 0.16, alpha: 1.0)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let activityDescLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor(red: 0.4, green: 0.38, blue: 0.36, alpha: 1.0) // Theme.clay
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(red: 0.22, green: 0.37, blue: 0.32, alpha: 1.0) // Theme.forest
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let communityToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = UIColor(red: 0.76, green: 0.42, blue: 0.35, alpha: 1.0) // Theme.terracotta
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()

    private let communityLabel: UILabel = {
        let label = UILabel()
        label.text = "Share with community"
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.4, green: 0.38, blue: 0.36, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Activity", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 0.76, green: 0.42, blue: 0.35, alpha: 1.0) // Theme.terracotta
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor(red: 0.4, green: 0.38, blue: 0.36, alpha: 1.0), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemRed
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - State

    private var parsedActivity: ShareActivityParser.ParsedActivity?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        extractSharedContent()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)

        view.addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(activityTitleLabel)
        containerView.addSubview(activityDescLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(communityLabel)
        containerView.addSubview(communityToggle)
        containerView.addSubview(saveButton)
        containerView.addSubview(cancelButton)
        containerView.addSubview(errorLabel)

        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            activityTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            activityTitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            activityTitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            activityDescLabel.topAnchor.constraint(equalTo: activityTitleLabel.bottomAnchor, constant: 8),
            activityDescLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            activityDescLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            timeLabel.topAnchor.constraint(equalTo: activityDescLabel.bottomAnchor, constant: 12),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            communityLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20),
            communityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

            communityToggle.centerYAnchor.constraint(equalTo: communityLabel.centerYAnchor),
            communityToggle.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            errorLabel.topAnchor.constraint(equalTo: communityToggle.bottomAnchor, constant: 16),
            errorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

            saveButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 16),
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 48),

            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 12),
            cancelButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
        ])
    }

    // MARK: - Content Extraction

    private func extractSharedContent() {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let attachments = extensionItem.attachments else {
            showError("No content to import")
            return
        }

        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                attachment.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { [weak self] item, error in
                    DispatchQueue.main.async {
                        if let text = item as? String {
                            self?.processSharedText(text)
                        } else {
                            self?.showError("Could not read shared text")
                        }
                    }
                }
                return
            }
        }

        showError("No text content found")
    }

    private func processSharedText(_ text: String) {
        guard let activity = ShareActivityParser.parse(text) else {
            showError("Could not parse activity.\nMake sure AI response is in JSON format.")
            return
        }

        guard ShareActivityParser.isValid(activity) else {
            showError("Invalid activity data")
            return
        }

        parsedActivity = activity
        displayActivity(activity)
    }

    private func displayActivity(_ activity: ShareActivityParser.ParsedActivity) {
        activityTitleLabel.text = activity.title
        activityDescLabel.text = activity.description
        timeLabel.text = "⏱ \(activity.expectedMinutes) min • \(activity.energy) energy • \(activity.context)"
        saveButton.isEnabled = true
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
        saveButton.isEnabled = false
        activityTitleLabel.text = "Unable to parse"
        activityDescLabel.text = "The shared content doesn't appear to be a valid activity format."
        timeLabel.text = ""
    }

    // MARK: - Actions

    @objc private func saveTapped() {
        guard let activity = parsedActivity else { return }

        // Save to shared storage for main app
        ShareActivityStorage.savePendingActivity(activity)

        // Queue for community if toggled
        if communityToggle.isOn {
            ShareActivityStorage.queueForCommunity(activity)
        }

        // Show success feedback
        saveButton.setTitle("✓ Added!", for: .normal)
        saveButton.backgroundColor = UIColor(red: 0.22, green: 0.37, blue: 0.32, alpha: 1.0) // Theme.forest

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }

    @objc private func cancelTapped() {
        extensionContext?.cancelRequest(withError: NSError(domain: "ShareExtension", code: 0, userInfo: nil))
    }
}

// MARK: - Parser (Extension-local copy to avoid framework dependency)

enum ShareActivityParser {
    struct ParsedActivity: Codable {
        let title: String
        let description: String
        let expectedMinutes: Int
        let energy: String
        let context: String
        let category: String
        let tags: [String]
        var submitToCommunity: Bool = false

        enum CodingKeys: String, CodingKey {
            case title, description, expectedMinutes, energy, context, category, tags
        }
    }

    static func parse(_ text: String) -> ParsedActivity? {
        let jsonString = extractJSON(from: text)
        guard let data = jsonString.data(using: .utf8) else { return nil }

        do {
            return try JSONDecoder().decode(ParsedActivity.self, from: data)
        } catch {
            return tryFallbackParse(text)
        }
    }

    private static func extractJSON(from text: String) -> String {
        guard let startIndex = text.firstIndex(of: "{"),
              let endIndex = text.lastIndex(of: "}") else {
            return text
        }
        return String(text[startIndex...endIndex])
    }

    private static func tryFallbackParse(_ text: String) -> ParsedActivity? {
        var title: String?
        var description: String?
        var minutes = 15

        for line in text.components(separatedBy: "\n") {
            let cleaned = line.trimmingCharacters(in: .whitespaces)
            if cleaned.lowercased().contains("activity:") {
                title = cleaned.replacingOccurrences(of: "**Activity:**", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "Activity:", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "**", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            if cleaned.lowercased().contains("description:") {
                description = cleaned.replacingOccurrences(of: "**Description:**", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "Description:", with: "", options: .caseInsensitive)
                    .replacingOccurrences(of: "**", with: "")
                    .trimmingCharacters(in: .whitespaces)
            }
            if cleaned.lowercased().contains("time:") {
                let numbers = cleaned.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                if let num = Int(numbers) { minutes = num }
            }
        }

        guard let activityTitle = title, !activityTitle.isEmpty else { return nil }

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

    static func isValid(_ activity: ParsedActivity) -> Bool {
        !activity.title.isEmpty && !activity.description.isEmpty &&
        activity.expectedMinutes > 0 && activity.expectedMinutes <= 180
    }
}

// MARK: - Shared Storage (Extension-local copy)

enum ShareActivityStorage {
    static let appGroupIdentifier = "group.com.dailymenu.shared"
    static let pendingActivitiesKey = "pendingActivities"
    static let communitySubmissionsKey = "communitySubmissions"

    private static var sharedDefaults: UserDefaults? {
        UserDefaults(suiteName: appGroupIdentifier)
    }

    static func savePendingActivity(_ activity: ShareActivityParser.ParsedActivity) {
        var pending = getPendingActivities()
        pending.append(activity)
        if let data = try? JSONEncoder().encode(pending) {
            sharedDefaults?.set(data, forKey: pendingActivitiesKey)
        }
    }

    static func getPendingActivities() -> [ShareActivityParser.ParsedActivity] {
        guard let data = sharedDefaults?.data(forKey: pendingActivitiesKey),
              let activities = try? JSONDecoder().decode([ShareActivityParser.ParsedActivity].self, from: data) else {
            return []
        }
        return activities
    }

    static func queueForCommunity(_ activity: ShareActivityParser.ParsedActivity) {
        var queue = getCommunityQueue()
        var activityWithFlag = activity
        activityWithFlag.submitToCommunity = true
        queue.append(activityWithFlag)
        if let data = try? JSONEncoder().encode(queue) {
            sharedDefaults?.set(data, forKey: communitySubmissionsKey)
        }
    }

    static func getCommunityQueue() -> [ShareActivityParser.ParsedActivity] {
        guard let data = sharedDefaults?.data(forKey: communitySubmissionsKey),
              let activities = try? JSONDecoder().decode([ShareActivityParser.ParsedActivity].self, from: data) else {
            return []
        }
        return activities
    }
}
