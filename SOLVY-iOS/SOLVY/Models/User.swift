
import Foundation

/// User model representing an authenticated user in the system
struct User: Codable, Identifiable {
    /// Unique identifier for the user
    let id: Int
    /// Username for authentication
    let username: String
    /// User's current balance
    var balance: Double
    /// Timestamp when the user was created
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case balance
        case createdAt = "created_at"
    }
}

extension User {
    /// Creates a mock user for testing and preview purposes
    static var mock: User {
        User(
            id: 1,
            username: "testuser",
            balance: 1000.0,
            createdAt: Date()
        )
    }
}
