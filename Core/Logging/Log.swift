import os

enum Log {
    private static let subsystem = "com.bmad.dailymenu"

    static let app = Logger(subsystem: subsystem, category: "app")
    static let network = Logger(subsystem: subsystem, category: "network")
    static let data = Logger(subsystem: subsystem, category: "data")
    static let ai = Logger(subsystem: subsystem, category: "ai")
    static let notifications = Logger(subsystem: subsystem, category: "notifications")
}
