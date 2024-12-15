import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var chainStatus: String = "Not Connected"
    @State private var isConnecting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Blockchain Status
                HStack {
                    Circle()
                        .fill(chainStatus == "Connected" ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(chainStatus)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Header
                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                let web3Service = Web3Service()
                                try await web3Service.connect()
                                // Test transaction with small amount
                                let hash = try await web3Service.sendTransaction(
                                    to: "test_wallet",
                                    amount: 0.001
                                )
                                print("Transaction sent: \(hash)")
                            } catch {
                                print("Blockchain error: \(error)")
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "link.circle.fill")
                            Text("Test Chain")
                        }
                        .font(.title2)
                    }
                }
                .padding(.horizontal)
                
                // Metrics Cards
                MetricsCardsView(summary: viewModel.summary)
                
                // Chart
                TransactionChartView(transactions: viewModel.transactions)
                    .frame(height: 200)
                    .padding()
                
                // Transactions List
                TransactionListView(transactions: viewModel.transactions)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .onAppear {
                viewModel.fetchTransactions()
            }
        }
    }
}

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
#endif
