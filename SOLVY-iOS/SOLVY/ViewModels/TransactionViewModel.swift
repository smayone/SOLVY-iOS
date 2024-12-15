import Foundation
import Combine

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var summary: TransactionSummary = TransactionSummary(
        totalTransactions: 0,
        totalVolume: 0,
        avgAmount: 0
    )
    @Published var isLoading = false
    @Published var error: String?
    
    private let networkService: NetworkService
    private var cancellables = Set<AnyCancellable>()
    
    init(networkService: NetworkService = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchTransactions() {
        isLoading = true
        error = nil
        
        // Implementation will be added when we set up the NetworkService
        // This is a placeholder for now
        self.mockTransactions()
    }
    
    private func mockTransactions() {
        // Temporary mock data for testing UI
        let mockTransactions = [
            Transaction(id: 1, userId: 1, amount: 100.0, type: .deposit, 
                       status: .completed, description: "Initial deposit", 
                       createdAt: Date()),
            Transaction(id: 2, userId: 1, amount: 50.0, type: .withdrawal, 
                       status: .completed, description: "ATM withdrawal", 
                       createdAt: Date().addingTimeInterval(-86400))
        ]
        
        self.transactions = mockTransactions
        self.updateSummary()
    }
    
    private func updateSummary() {
        let total = transactions.reduce(0.0) { $0 + $1.amount }
        let avg = transactions.isEmpty ? 0 : total / Double(transactions.count)
        
        summary = TransactionSummary(
            totalTransactions: transactions.count,
            totalVolume: total,
            avgAmount: avg
        )
    }
}