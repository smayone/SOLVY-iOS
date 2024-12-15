import Foundation

struct TransactionRequest: Codable {
    let to: String
    let amount: Double
    let chainId: Int
}

struct TransactionResponse: Codable {
    let hash: String
    let status: String
    let blockNumber: Int?
}

enum BlockchainError: Error {
    case unauthorized
    case connectionFailed
    case transactionFailed
    case invalidAddress
    case insufficientFunds
    
    var localizedDescription: String {
        switch self {
        case .unauthorized:
            return "Unauthorized: Please check your API key"
        case .connectionFailed:
            return "Failed to connect to blockchain"
        case .transactionFailed:
            return "Transaction failed"
        case .invalidAddress:
            return "Invalid blockchain address"
        case .insufficientFunds:
            return "Insufficient funds for transaction"
        }
    }
}
struct TransactionRequest: Codable {
    let to: String
    let amount: Double
    let chainId: Int
}

struct TransactionResponse: Codable {
    let hash: String
    let status: String
}

enum TransactionStatus {
    case pending
    case completed
    case failed
}
