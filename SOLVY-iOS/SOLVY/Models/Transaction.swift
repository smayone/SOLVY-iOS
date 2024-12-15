import Foundation

enum TransactionType: String, Codable {
    case deposit
    case withdrawal
    case transfer
}

enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
}

struct Transaction: Codable, Identifiable {
    let id: Int
    let userId: Int
    let amount: Double
    let type: TransactionType
    let status: TransactionStatus
    let description: String?
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
