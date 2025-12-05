import Foundation
import OSLog
import os.signpost

/// Performance monitoring with OSLog signposts and metrics
final class PerformanceMonitor {
    static let shared = PerformanceMonitor()

    private let log = OSLog(subsystem: "com.dailymenu.app", category: .pointsOfInterest)
    private let signpostLog = OSLog(subsystem: "com.dailymenu.app", category: "Performance")

    private init() {}

    // MARK: - Signpost Markers

    /// Begin a signpost interval for app launch
    func beginAppLaunch() -> OSSignpostID {
        let signpostID = OSSignpostID(log: signpostLog)
        os_signpost(.begin, log: signpostLog, name: "App Launch", signpostID: signpostID,
                    "Starting app launch sequence")
        return signpostID
    }

    /// End app launch signpost
    func endAppLaunch(signpostID: OSSignpostID) {
        os_signpost(.end, log: signpostLog, name: "App Launch", signpostID: signpostID,
                    "App launch complete")
    }

    /// Begin suggestion loading signpost
    func beginSuggestionLoad() -> OSSignpostID {
        let signpostID = OSSignpostID(log: signpostLog)
        os_signpost(.begin, log: signpostLog, name: "Suggestion Load", signpostID: signpostID,
                    "Loading suggestions from Core Data")
        return signpostID
    }

    /// End suggestion loading signpost
    func endSuggestionLoad(signpostID: OSSignpostID, count: Int) {
        os_signpost(.end, log: signpostLog, name: "Suggestion Load", signpostID: signpostID,
                    "Loaded %d suggestions", count)
    }

    /// Begin seed data load signpost
    func beginSeedLoad() -> OSSignpostID {
        let signpostID = OSSignpostID(log: signpostLog)
        os_signpost(.begin, log: signpostLog, name: "Seed Load", signpostID: signpostID,
                    "Loading seed data")
        return signpostID
    }

    /// End seed data load signpost
    func endSeedLoad(signpostID: OSSignpostID, count: Int) {
        os_signpost(.end, log: signpostLog, name: "Seed Load", signpostID: signpostID,
                    "Loaded %d seed activities", count)
    }

    /// Begin Core Data fetch signpost
    func beginCoreDataFetch(entity: String) -> OSSignpostID {
        let signpostID = OSSignpostID(log: signpostLog)
        os_signpost(.begin, log: signpostLog, name: "Core Data Fetch", signpostID: signpostID,
                    "Fetching %{public}s", entity)
        return signpostID
    }

    /// End Core Data fetch signpost
    func endCoreDataFetch(signpostID: OSSignpostID, entity: String, count: Int) {
        os_signpost(.end, log: signpostLog, name: "Core Data Fetch", signpostID: signpostID,
                    "Fetched %d %{public}s", count, entity)
    }

    // MARK: - Event Markers

    /// Log a point-of-interest event
    func logEvent(_ name: StaticString, _ message: String = "") {
        os_log(.info, log: log, "%{public}@: %{public}@", name.description, message)
    }

    /// Log a performance interval
    func measureInterval<T>(_ name: StaticString, operation: () throws -> T) rethrows -> T {
        let start = Date()
        defer {
            let elapsed = Date().timeIntervalSince(start)
            os_log(.info, log: log, "%{public}@ took %.2f ms", name.description, elapsed * 1000)
        }
        return try operation()
    }

    /// Async version of measureInterval
    func measureInterval<T>(_ name: StaticString, operation: () async throws -> T) async rethrows -> T {
        let start = Date()
        defer {
            let elapsed = Date().timeIntervalSince(start)
            os_log(.info, log: log, "%{public}@ took %.2f ms", name.description, elapsed * 1000)
        }
        return try await operation()
    }
}

// MARK: - Performance Metrics

/// Key performance metrics for monitoring
struct PerformanceMetrics {
    static let launchToSuggestionsTarget: TimeInterval = 2.0 // 2 seconds max
    static let seedLoadTarget: TimeInterval = 1.5 // 1.5 seconds max
    static let suggestionFetchTarget: TimeInterval = 0.1 // 100ms max
    static let scrollFrameRate: Double = 60.0 // 60 fps target
}

// MARK: - Memory Monitoring

/// Memory usage monitoring
final class MemoryMonitor {
    static let shared = MemoryMonitor()

    private let log = Logger(subsystem: "com.dailymenu.app", category: "memory")

    private init() {}

    /// Get current memory usage in MB
    func currentMemoryUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let result = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        guard result == KERN_SUCCESS else {
            log.error("Failed to get memory info")
            return 0
        }

        let usedMB = Double(info.resident_size) / 1024.0 / 1024.0
        return usedMB
    }

    /// Log current memory usage
    func logMemoryUsage(context: String = "") {
        let usage = currentMemoryUsage()
        log.info("Memory usage\(context.isEmpty ? "" : " (\(context))"): \(String(format: "%.2f", usage)) MB")
    }

    /// Monitor memory usage during operation
    func monitorOperation<T>(_ name: String, operation: () throws -> T) rethrows -> T {
        let beforeMB = currentMemoryUsage()
        let result = try operation()
        let afterMB = currentMemoryUsage()
        let deltaMB = afterMB - beforeMB

        log.info("\(name): Memory before: \(String(format: "%.2f", beforeMB)) MB, after: \(String(format: "%.2f", afterMB)) MB, delta: \(String(format: "%.2f", deltaMB)) MB")

        return result
    }
}
