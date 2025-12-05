import Foundation

struct LocalGenerator {
    func suggestions(seed: [Activity], timeMinutes: Int, energy: Activity.Energy, context: Activity.Context) -> [Activity] {
        // Placeholder ranking; future Core ML integration sits behind flags.
        return seed.filter { _ in true }.prefix(3).map { $0 }
    }
}
