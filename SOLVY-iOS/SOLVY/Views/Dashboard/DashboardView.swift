import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = TransactionViewModel()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header
                HStack {
                    Text("Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Spacer()
                    Button(action: {
                        // Add new transaction
                    }) {
                        Image(systemName: "plus")
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
