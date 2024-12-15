import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var chainStatus: ChainConnectionStatus = .disconnected
    
    private let web3Service: Web3Service
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    enum ChainConnectionStatus {
        case connected
        case disconnected
        case error(String)
        
        var description: String {
            switch self {
            case .connected:
                return "Connected"
            case .disconnected:
                return "Disconnected"
            case .error(let message):
                return "Error: \(message)"
            }
        }
    }
    
    init(web3Service: Web3Service = Web3Service(), 
         networkService: NetworkService = NetworkService()) {
        self.web3Service = web3Service
        self.networkService = networkService
        setupChainConnection()
    }
    
    func setupChainConnection() {
        Task {
            do {
                try await web3Service.connect()
                await MainActor.run {
                    self.chainStatus = .connected
                }
            } catch {
                await MainActor.run {
                    self.chainStatus = .error(error.localizedDescription)
                }
            }
        }
    }
    
    func refreshDashboard() {
        isLoading = true
        error = nil
        
        // Fetch latest transactions
        Task {
            do {
                let hash = try await web3Service.sendTransaction(
                    to: "test_address",
                    amount: 0.001
                )
                print("Test transaction hash: \(hash)")
                
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func monitorTransaction(hash: String) {
        Task {
            do {
                let status = try await web3Service.monitorTransaction(hash: hash)
                print("Transaction status: \(status)")
            } catch {
                await MainActor.run {
                    self.error = "Failed to monitor transaction: \(error.localizedDescription)"
                }
            }
        }
    }
}
