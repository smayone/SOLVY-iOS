import Foundation

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
            return "Unauthorized access: API key missing or invalid"
        case .invalidResponse:
            return "Invalid response from blockchain network"
        case .networkError:
            return "Network communication error"
        }
    }
}

class Web3Service {
    private let chainURL: URL
    private var apiKey: String?
    private var isConnected: Bool = false
    private let session: URLSession
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()
    
    init(chainURL: URL = ChainConfig.endpoint, 
         session: URLSession = .shared) {
        self.chainURL = chainURL
        self.session = session
        setupApiKey()
        setupJSONFormatting()
    }
    
    private func setupJSONFormatting() {
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
    }
    
    private func setupApiKey() {
        if let key = KeychainService.shared.retrieve(key: "solvy_chain_api_key") {
            self.apiKey = key
        }
    }
    
    func connect() async throws {
        guard !isConnected else { return }
        
        return try await executeWithRetry {
            let request = URLRequest(url: chainURL.appendingPathComponent("connect"))
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BlockchainError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                self.isConnected = true
            case 401:
                throw BlockchainError.unauthorized
            case 500...:
                throw BlockchainError.networkError
            default:
                throw BlockchainError.connectionFailed
            }
        }
    }
    
    func disconnect() {
        isConnected = false
    }
    
    func sendTransaction(to: String, amount: Double) async throws -> String {
        guard isConnected else {
            try await connect()
        }
        
        return try await executeWithRetry {
            guard let apiKey = self.apiKey else {
                throw BlockchainError.unauthorized
            }
            
            var request = URLRequest(url: chainURL.appendingPathComponent("transaction"))
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let transaction = TransactionRequest(
                to: to,
                amount: amount,
                chainId: ChainConfig.chainId
            )
            
            request.httpBody = try encoder.encode(transaction)
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BlockchainError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                let result = try decoder.decode(TransactionResponse.self, from: data)
                return result.hash
            case 401:
                throw BlockchainError.unauthorized
            case 400:
                throw BlockchainError.invalidAddress
            case 402:
                throw BlockchainError.insufficientFunds
            default:
                throw BlockchainError.transactionFailed
            }
        }
    }
    
    func monitorTransaction(hash: String) async throws -> TransactionStatus {
        guard isConnected else {
            try await connect()
        }
        
        return try await executeWithRetry {
            guard let apiKey = self.apiKey else {
                throw BlockchainError.unauthorized
            }
            
            var request = URLRequest(url: chainURL.appendingPathComponent("transaction/\(hash)"))
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw BlockchainError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200:
                let result = try decoder.decode(TransactionResponse.self, from: data)
                return result.status == "completed" ? .completed :
                       result.status == "pending" ? .pending : .failed
            case 404:
                return .pending
            default:
                throw BlockchainError.networkError
            }
        }
    }
}

// Extension to handle key management
extension Web3Service {
    func securelyStoreKey(_ key: String) {
        KeychainService.shared.save(key: "solvy_chain_api_key", value: key)
    }
    
    private func retrieveKey() -> String? {
        return KeychainService.shared.retrieve(key: "solvy_chain_api_key")
    }
}

// Extension for error handling and retry logic
extension Web3Service {
    private func executeWithRetry<T>(
        maxAttempts: Int = 3,
        operation: () async throws -> T
    ) async throws -> T {
        var lastError: Error?
        
        for attempt in 1...maxAttempts {
            do {
                return try await operation()
            } catch {
                lastError = error
                print("Attempt \(attempt) failed: \(error.localizedDescription)")
                if attempt < maxAttempts {
                    try await Task.sleep(nanoseconds: UInt64(pow(2.0, Double(attempt)) * 1_000_000_000))
                }
            }
        }
        
        throw lastError ?? BlockchainError.connectionFailed
    }
}
