import SwiftUI
import Combine

struct TransactionListView: View {
    @StateObject private var viewModel = TransactionViewModel()
    @State private var searchText = ""
    @State private var selectedType: TransactionType?
    @State private var sortOrder: SortOrder = .newest
    
    enum SortOrder: String, CaseIterable {
        case newest = "Newest First"
        case oldest = "Oldest First"
        case highestAmount = "Highest Amount"
        case lowestAmount = "Lowest Amount"
    }
    
    private var filteredTransactions: [Transaction] {
        viewModel.transactions
            .filter { transaction in
                // Apply type filter
                if let selectedType = selectedType {
                    guard transaction.type == selectedType else { return false }
                }
                
                // Apply search filter
                if !searchText.isEmpty {
                    let lowercasedSearch = searchText.lowercased()
                    return transaction.type.rawValue.lowercased().contains(lowercasedSearch) ||
                           transaction.description?.lowercased().contains(lowercasedSearch) ?? false
                }
                
                return true
            }
            .sorted { first, second in
                switch sortOrder {
                case .newest:
                    return first.createdAt > second.createdAt
                case .oldest:
                    return first.createdAt < second.createdAt
                case .highestAmount:
                    return first.amount > second.amount
                case .lowestAmount:
                    return first.amount < second.amount
                }
            }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Search and Filter Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search transactions", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal)
            
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(title: "All", isSelected: selectedType == nil) {
                        selectedType = nil
                    }
                    
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        FilterPill(
                            title: type.rawValue.capitalized,
                            isSelected: selectedType == type
                        ) {
                            selectedType = type
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Sort Menu
            Menu {
                Button("Newest First") { sortOrder = .newest }
                Button("Oldest First") { sortOrder = .oldest }
                Button("Highest Amount") { sortOrder = .highestAmount }
                Button("Lowest Amount") { sortOrder = .lowestAmount }
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.horizontal)
            
            if viewModel.isLoading {
                LoadingView("Loading transactions...")
            } else if filteredTransactions.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    Text("No transactions found")
                        .font(.headline)
                    Text("Try adjusting your filters")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                }
            }
        }
        .navigationTitle("Transactions")
        .onAppear {
            viewModel.fetchTransactions()
        }
    }
}

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(20)
        }
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TransactionListView()
        }
    }
}
#endif