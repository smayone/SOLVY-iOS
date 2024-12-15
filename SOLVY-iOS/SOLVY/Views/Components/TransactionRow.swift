import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            // Transaction Type Icon
            Image(systemName: iconName)
                .foregroundColor(iconColor)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .clipShape(Circle())
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.type.rawValue.capitalized)
                    .font(.headline)
                if let description = transaction.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(formattedAmount)
                    .font(.headline)
                    .foregroundColor(amountColor)
                Text(transaction.status.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(statusColor)
            }
        }
        .padding(.vertical, 8)
    }
    
    private var iconName: String {
        switch transaction.type {
        case .deposit:
            return "arrow.down.circle.fill"
        case .withdrawal:
            return "arrow.up.circle.fill"
        case .transfer:
            return "arrow.left.arrow.right.circle.fill"
        }
    }
    
    private var iconColor: Color {
        switch transaction.type {
        case .deposit:
            return .green
        case .withdrawal:
            return .red
        case .transfer:
            return .blue
        }
    }
    
    private var amountColor: Color {
        switch transaction.type {
        case .deposit:
            return .green
        case .withdrawal, .transfer:
            return .red
        }
    }
    
    private var statusColor: Color {
        switch transaction.status {
        case .completed:
            return .green
        case .pending:
            return .orange
        case .failed:
            return .red
        }
    }
    
    private var formattedAmount: String {
        let prefix = transaction.type == .deposit ? "+" : "-"
        return "\(prefix)$\(String(format: "%.2f", transaction.amount))"
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: transaction.createdAt)
    }
}

#if DEBUG
struct TransactionRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TransactionRow(transaction: Transaction(
                id: 1,
                userId: 1,
                amount: 100.0,
                type: .deposit,
                status: .completed,
                description: "Initial deposit",
                createdAt: Date()
            ))
            
            TransactionRow(transaction: Transaction(
                id: 2,
                userId: 1,
                amount: 50.0,
                type: .withdrawal,
                status: .pending,
                description: "ATM withdrawal",
                createdAt: Date()
            ))
        }
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
