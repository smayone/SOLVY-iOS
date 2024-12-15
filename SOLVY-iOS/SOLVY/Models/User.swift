import Foundation

/// User model representing an authenticated user in the system
struct User: Codable, Identifiable {
    /// Unique identifier for the user
    let id: Int
    /// Username for authentication
    let username: String
    /// User's current balance
    var balance: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case username
        case balance
    }
}
