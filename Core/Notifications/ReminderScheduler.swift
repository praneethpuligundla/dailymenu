import Foundation
import UserNotifications

enum ReminderScheduler {
    static func requestAuthorization() async throws -> Bool {
        try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
    }

    static func scheduleDailyReminder(at hour: Int, minute: Int, id: String = "daily-menu-reminder") async {
        let content = UNMutableNotificationContent()
        content.title = "Ready for a tiny joy?"
        content.body = "Pick time, energy, context for a fresh suggestion."
        content.sound = .default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        _ = try? await UNUserNotificationCenter.current().add(request)
    }

    static func cancelReminder(id: String = "daily-menu-reminder") {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}
