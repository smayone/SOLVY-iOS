import Foundation
import Combine

/// Custom error types for network operations
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case unknown
}

/// Service class handling all network operations
class NetworkService {
    /// Base URL for API endpoints
    private let baseURL = "http://your-api-url.com/api"
    /// URLSession for network requests
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Authenticates user with username and password
    /// - Parameters:
    ///   - username: User's username
    ///   - password: User's password
    /// - Returns: Publisher that emits authenticated User or Error
    func login(username: String, password: String) -> AnyPublisher<User, Error> {
        guard let url = URL(string: "\(baseURL)/login") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["username": username, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: User.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    /// Logs out the current user
    /// - Returns: Publisher that emits Void on success or Error
    func logout() -> AnyPublisher<Void, Error> {
        guard let url = URL(string: "\(baseURL)/logout") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return session.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
