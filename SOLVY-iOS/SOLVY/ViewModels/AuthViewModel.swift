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
    }
    
    func login(username: String, password: String) {
        isLoading = true
        error = nil
        
        // Implementation will connect to your web API
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
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        networkService.logout()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.currentUser = nil
                self?.isAuthenticated = false
            }
            .store(in: &cancellables)
    }
}
