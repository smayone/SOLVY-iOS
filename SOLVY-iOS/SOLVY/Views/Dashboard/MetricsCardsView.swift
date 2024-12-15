import SwiftUI

struct TransactionSummary {
    let totalTransactions: Int
    let totalVolume: Double
    let avgAmount: Double
}

struct MetricsCardsView: View {
    let summary: TransactionSummary
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                MetricCard(
                    title: "Total Transactions",
                    value: "\(summary.totalTransactions)",
                    icon: "arrow.left.arrow.right"
                )
                
                MetricCard(
                    title: "Total Volume",
                    value: "$\(String(format: "%.2f", summary.totalVolume))",
                    icon: "dollarsign.circle"
                )
                
                MetricCard(
                    title: "Average Amount",
                    value: "$\(String(format: "%.2f", summary.avgAmount))",
                    icon: "chart.bar"
                )
            }
            .padding(.horizontal)
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: icon)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(width: 160)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#if DEBUG
struct MetricsCardsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsCardsView(summary: TransactionSummary(
            totalTransactions: 125,
            totalVolume: 15234.50,
            avgAmount: 121.88
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}
#endif
