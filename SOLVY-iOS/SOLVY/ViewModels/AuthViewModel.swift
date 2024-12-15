import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var error: String?
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
        checkAuthenticationStatus()
    }
    
    private func checkAuthenticationStatus() {
        // Check if user is already authenticated
        if let savedToken = KeychainService.shared.retrieve(key: "auth_token") {
            validateToken(savedToken)
        }
    }
    
    private func validateToken(_ token: String) {
        isLoading = true
        // Implement token validation with your backend
        // This is a placeholder that simulates token validation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.isLoading = false
            // For demo purposes, consider token valid if it exists
            if !token.isEmpty {
                self?.isAuthenticated = true
            }
        }
    }
    
    func login(username: String, password: String) {
        guard !username.isEmpty && !password.isEmpty else {
            error = "Username and password are required"
            return
        }
        
        isLoading = true
        error = nil
        
        networkService.login(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
                // Save authentication token
                KeychainService.shared.save(key: "auth_token", value: "sample_token")
            }
            .store(in: &cancellables)
    }
    
    func register(username: String, password: String) {
        guard !username.isEmpty && !password.isEmpty else {
            error = "Username and password are required"
            return
        }
        
        isLoading = true
        error = nil
        
        networkService.register(username: username, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] user in
                self?.currentUser = user
                self?.isAuthenticated = true
                // Save authentication token
                KeychainService.shared.save(key: "auth_token", value: "sample_token")
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        isLoading = true
        
        networkService.logout()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.currentUser = nil
                self?.isAuthenticated = false
                // Remove authentication token
                _ = KeychainService.shared.save(key: "auth_token", value: "")
            }
            .store(in: &cancellables)
    }
    
    func clearError() {
        error = nil
    }
}
