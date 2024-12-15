import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case unauthorized
    case unknown
}

class NetworkService {
    private let baseURL = "http://your-api-url.com/api"
    private var session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
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
