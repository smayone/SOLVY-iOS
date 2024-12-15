
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

enum TransactionStatus: String, Codable {
    case pending
    case completed
    case failed
    
    var description: String {
        switch self {
        case .pending: return "Transaction is being processed"
        case .completed: return "Transaction completed successfully"
        case .failed: return "Transaction failed"
        }
    }
}

enum BlockchainError: Error {
    case connectionFailed
    case transactionFailed
    case invalidAddress
    case insufficientFunds
    case unauthorized
    case invalidResponse
    case networkError
    
    var localizedDescription: String {
        switch self {
        case .connectionFailed:
            return "Failed to connect to blockchain network"
        case .transactionFailed:
            return "Transaction failed to process"
        case .invalidAddress:
            return "Invalid blockchain address provided"
        case .insufficientFunds:
            return "Insufficient funds for transaction"
        case .unauthorized:
            return "Unauthorized: Please check your API key"
        case .invalidResponse:
            return "Invalid response from blockchain network"
        case .networkError:
            return "Network communication error"
        }
    }
}

struct ChainConfiguration: Codable {
    let chainId: Int
    let name: String
    let rpcEndpoint: URL
    let explorerURL: URL
    let isTestnet: Bool
}
