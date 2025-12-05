import Foundation

struct Activity: Identifiable, Codable, Equatable {
    enum Energy: String, Codable {
        case low, okay, upForSomething
    }

    enum Context: String, Codable {
        case solo, withSomeone
    }

    enum Category: String, Codable {
        case starter, main, dessert, connection, lowBattery
    }

    var id: UUID
    var title: String
    var summary: String
    var expectedMinutes: Int
    var energy: Energy
    var context: Context
    var category: Category
    var repeatable: Bool
    var tags: [String]
}
