import Foundation

/// Represents different types of transactions in the system
enum TransactionType: String, Codable {
    case deposit
    case withdrawal
    case transfer
}

/// Represents the current status of a transaction
enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
}

/// Transaction model representing a financial transaction in the system
struct Transaction: Codable, Identifiable {
    /// Unique identifier for the transaction
    let id: Int
    /// ID of the user who initiated the transaction
    let userId: Int
    /// Amount of the transaction
    let amount: Double
    /// Type of transaction (deposit, withdrawal, transfer)
    let type: TransactionType
    /// Current status of the transaction
    let status: TransactionStatus
    /// Optional description of the transaction
    let description: String?
    /// Timestamp when the transaction was created
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId
        case amount
        case type
        case status
        case description
        case createdAt
    }
}
