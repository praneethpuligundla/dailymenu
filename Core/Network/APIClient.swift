import Foundation

struct APIClient {
    enum APIError: Error {
        case unavailable
        case decoding
    }

    var baseURL: URL? = URL(string: "https://api.dailymenu.example")

    func fetchActivities() async throws -> [Activity] {
        throw APIError.unavailable
    }
}
