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
        
        networkService.fetchTransactions()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] transactions in
                self?.transactions = transactions
                self?.updateSummary()
            }
            .store(in: &cancellables)
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
    
    func createTransaction(amount: Double, type: TransactionType, description: String?) {
        isLoading = true
        error = nil
        
        networkService.createTransaction(amount: amount, type: type, description: description)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] transaction in
                self?.transactions.insert(transaction, at: 0)
                self?.updateSummary()
            }
            .store(in: &cancellables)
    }
}
