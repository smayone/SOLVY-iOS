import SwiftUI

struct TransactionSummary {
    let totalTransactions: Int
    let totalVolume: Double
    let avgAmount: Double
    var successRate: Double = 0.0
    
    var formattedSuccessRate: String {
        String(format: "%.1f%%", successRate * 100)
    }
}

struct MetricsCardsView: View {
    let summary: TransactionSummary
    @State private var isAnimating = false
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Transaction Count Card
                MetricCard(
                    title: "Total Transactions",
                    value: "\(summary.totalTransactions)",
                    subtitle: "All time",
                    icon: "arrow.left.arrow.right",
                    gradient: Gradient(colors: [.blue.opacity(0.8), .blue])
                )
                .transition(.scale)
                
                // Volume Card
                MetricCard(
                    title: "Total Volume",
                    value: "$\(String(format: "%.2f", summary.totalVolume))",
                    subtitle: "Transaction volume",
                    icon: "dollarsign.circle",
                    gradient: Gradient(colors: [.green.opacity(0.8), .green])
                )
                
                // Average Amount Card
                MetricCard(
                    title: "Average Amount",
                    value: "$\(String(format: "%.2f", summary.avgAmount))",
                    subtitle: "Per transaction",
                    icon: "chart.bar",
                    gradient: Gradient(colors: [.purple.opacity(0.8), .purple])
                )
                
                // Success Rate Card
                MetricCard(
                    title: "Success Rate",
                    value: summary.formattedSuccessRate,
                    subtitle: "Completed transactions",
                    icon: "checkmark.circle",
                    gradient: Gradient(colors: [.orange.opacity(0.8), .orange])
                )
            }
            .padding(.horizontal)
            .opacity(isAnimating ? 1 : 0)
            .offset(x: isAnimating ? 0 : 50)
            .onAppear {
                withAnimation(.easeOut(duration: 0.5)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct MetricCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let gradient: Gradient
    
    @State private var isHovered = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(Circle())
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 180)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: isHovered ? 8 : 2)
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

#if DEBUG
struct MetricsCardsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Light mode preview
            MetricsCardsView(summary: TransactionSummary(
                totalTransactions: 125,
                totalVolume: 15234.50,
                avgAmount: 121.88,
                successRate: 0.95
            ))
            .previewLayout(.sizeThatFits)
            .padding()
            
            // Dark mode preview
            MetricsCardsView(summary: TransactionSummary(
                totalTransactions: 125,
                totalVolume: 15234.50,
                avgAmount: 121.88,
                successRate: 0.95
            ))
            .previewLayout(.sizeThatFits)
            .padding()
            .preferredColorScheme(.dark)
        }
    }
}
#endif
