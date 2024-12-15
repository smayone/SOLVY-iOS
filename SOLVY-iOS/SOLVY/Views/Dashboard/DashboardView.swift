import SwiftUI

struct DashboardView: View {
    @StateObject private var transactionViewModel = TransactionViewModel()
@StateObject private var dashboardViewModel = DashboardViewModel()
    @State private var showingNewTransaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with Chain Status
                HStack {
                    Text("SOLVY")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Chain Status Indicator
                    HStack(spacing: 8) {
                        Circle()
                            .fill(chainStatusColor)
                            .frame(width: 10, height: 10)
                        Text(dashboardViewModel.chainStatus.description)
                            .font(.caption)
                    }
                    .padding(.horizontal)
                }
                
                // Transaction Summary
                VStack(spacing: 10) {
                    Text("Total Volume: $\(String(format: "%.2f", transactionViewModel.summary.totalVolume))")
                        .font(.headline)
                    Text("Transactions: \(transactionViewModel.summary.totalTransactions)")
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                
                // Recent Transactions with "View All" Button
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Recent Transactions")
                            .font(.headline)
                        Spacer()
                        NavigationLink("View All") {
                            TransactionListView()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                    
                    List(transactionViewModel.transactions.prefix(5)) { transaction in
                        TransactionRow(transaction: transaction)
                    }
                }
                
                // New Transaction Button
                Button(action: { showingNewTransaction = true }) {
                    Label("New Transaction", systemImage: "plus.circle.fill")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .onAppear {
                viewModel.fetchTransactions()
            }
            .navigationBarHidden(true)
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(transaction.type.rawValue.capitalized)
                    .font(.headline)
                if let description = transaction.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
    // Chain status color
    private var chainStatusColor: Color {
        switch dashboardViewModel.chainStatus {
        case .connected:
            return .green
        case .disconnected:
            return .red
        case .error:
            return .orange
        }
    }
            Text("$\(String(format: "%.2f", transaction.amount))")
                .font(.headline)
                .foregroundColor(transaction.type == .deposit ? .green : .red)
        }
        .padding(.vertical, 8)
    }
}

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
#endif
