import Foundation
import Network
import OSLog

/// Simple reachability monitor for offline-first behavior
@MainActor
final class Reachability: ObservableObject {
    @Published var isConnected: Bool = true
    @Published var connectionType: NWInterface.InterfaceType?

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.dailymenu.reachability")
    private let log = Logger(subsystem: "com.dailymenu.app", category: "network")

    static let shared = Reachability()

    private init() {
        startMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = path.status == .satisfied
                self?.connectionType = path.availableInterfaces.first?.type
                self?.log.info("Network status: \(path.status == .satisfied ? "connected" : "offline")")
            }
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
