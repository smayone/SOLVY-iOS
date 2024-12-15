import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var showingNewTransaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                Text("SOLVY")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                // Transaction Summary
                VStack(spacing: 10) {
                    Text("Total Volume: $\(String(format: "%.2f", viewModel.summary.totalVolume))")
                        .font(.headline)
                    Text("Transactions: \(viewModel.summary.totalTransactions)")
                        .font(.subheadline)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                
                // Transaction List
                List(viewModel.transactions) { transaction in
                    TransactionRow(transaction: transaction)
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
