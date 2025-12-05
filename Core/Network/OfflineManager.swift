import Foundation
import Combine

/// Manages offline resilience and deferred network operations
@MainActor
final class OfflineManager: ObservableObject {
    @Published var isOffline: Bool = false
    @Published var deferredOperations: [DeferredOperation] = []

    private let reachability: Reachability
    private var cancellables = Set<AnyCancellable>()

    init(reachability: Reachability = .shared) {
        self.reachability = reachability

        // Monitor reachability changes
        reachability.$isConnected
            .map { !$0 }
            .assign(to: &$isOffline)

        // Process deferred operations when coming back online
        reachability.$isConnected
            .filter { $0 }
            .sink { [weak self] _ in
                Task { @MainActor in
                    await self?.processDeferredOperations()
                }
            }
            .store(in: &cancellables)
    }

    /// Defer an operation that requires network connectivity
    func deferOperation(_ operation: DeferredOperation) {
        deferredOperations.append(operation)
    }

    /// Process all deferred operations when network becomes available
    private func processDeferredOperations() async {
        guard !isOffline else { return }

        let operations = deferredOperations
        deferredOperations.removeAll()

        for operation in operations {
            await operation.execute()
        }
    }

    /// Check if an operation should be deferred
    func shouldDefer(operation: NetworkOperation) -> Bool {
        return isOffline && operation.requiresNetwork
    }
}

// MARK: - Deferred Operation Model

struct DeferredOperation: Identifiable {
    let id = UUID()
    let type: OperationType
    let execute: @Sendable () async -> Void
    let createdAt: Date

    init(type: OperationType, execute: @escaping @Sendable () async -> Void) {
        self.type = type
        self.execute = execute
        self.createdAt = Date()
    }

    enum OperationType {
        case sync
        case cloudSubmission
        case analytics
    }
}

// MARK: - Network Operation Protocol

protocol NetworkOperation {
    var requiresNetwork: Bool { get }
    func executeOffline() async
    func executeOnline() async
}

extension NetworkOperation {
    /// Default offline execution is a no-op
    func executeOffline() async {}
}
