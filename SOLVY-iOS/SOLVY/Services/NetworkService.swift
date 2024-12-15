import Foundation
import Combine

/// Custom error types for network operations
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case serverError
    case decodingError
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL provided"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .serverError:
            return "Server error occurred"
        case .decodingError:
            return "Error decoding response"
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

/// Service class handling all network operations
class NetworkService {
    /// Base URL for API endpoints
    private let baseURL = "https://api.solvy.app/v1"
    /// URLSession for network requests
    private var session: URLSession
    /// JSON decoder with custom date formatting
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }
    
    /// Generic network request method
    private func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: [String: Any]? = nil
    ) -> AnyPublisher<T, Error> {
        guard let url = URL(string: "\(baseURL)/\(endpoint)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        }
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw NetworkError.unauthorized
                case 500...599:
                    throw NetworkError.serverError
                default:
                    throw NetworkError.unknown
                }
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                if error is DecodingError {
                    return NetworkError.decodingError
                }
                return error
            }
            .eraseToAnyPublisher()
    }
    
    /// Authenticates user with username and password
    /// - Parameters:
    ///   - username: User's username
    ///   - password: User's password
    /// - Returns: Publisher that emits authenticated User or Error
    func login(username: String, password: String) -> AnyPublisher<User, Error> {
        return request(
            endpoint: "auth/login",
            method: "POST",
            body: ["username": username, "password": password]
        )
    }
    
    /// Registers a new user
    /// - Parameters:
    ///   - username: Desired username
    ///   - password: Desired password
    /// - Returns: Publisher that emits created User or Error
    func register(username: String, password: String) -> AnyPublisher<User, Error> {
        return request(
            endpoint: "auth/register",
            method: "POST",
            body: ["username": username, "password": password]
        )
    }
    
    /// Logs out the current user
    /// - Returns: Publisher that emits Void on success or Error
    func logout() -> AnyPublisher<Void, Error> {
        return request(endpoint: "auth/logout", method: "POST")
    }
    
    /// Fetches transactions for the authenticated user
    /// - Returns: Publisher that emits array of Transactions or Error
    func fetchTransactions() -> AnyPublisher<[Transaction], Error> {
        return request(endpoint: "transactions")
    }
    
    /// Creates a new transaction
    /// - Parameter transaction: Transaction details to create
    /// - Returns: Publisher that emits created Transaction or Error
    func createTransaction(_ transaction: Transaction) -> AnyPublisher<Transaction, Error> {
        return request(
            endpoint: "transactions",
            method: "POST",
            body: [
                "amount": transaction.amount,
                "type": transaction.type.rawValue,
                "description": transaction.description ?? ""
            ]
        )
    }
}
