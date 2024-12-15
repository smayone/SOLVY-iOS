import SwiftUI

struct ChartView: View {
    let data: [Transaction]
    let timeframe: Timeframe
    
    enum Timeframe {
        case day
        case week
        case month
        
        var title: String {
            switch self {
            case .day: return "24 Hours"
            case .week: return "7 Days"
            case .month: return "30 Days"
            }
        }
    }
    
    private var chartData: [(String, Double)] {
        // Group transactions by date and sum amounts
        let calendar = Calendar.current
        let now = Date()
        
        let grouped = Dictionary(grouping: data) { transaction -> Date in
            switch timeframe {
            case .day:
                return calendar.date(bySettingHour: calendar.component(.hour, from: transaction.createdAt),
                                  minute: 0,
                                  second: 0,
                                  of: transaction.createdAt) ?? transaction.createdAt
            case .week:
                return calendar.startOfDay(for: transaction.createdAt)
            case .month:
                let components = calendar.dateComponents([.year, .month, .day], from: transaction.createdAt)
                return calendar.date(from: components) ?? transaction.createdAt
            }
        }
        
        let summed = grouped.mapValues { transactions in
            transactions.reduce(0) { $0 + $1.amount }
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = timeframe == .day ? "HH:mm" : "MM/dd"
        
        return summed.map { (formatter.string(from: $0.key), $0.value) }
            .sorted { $0.0 < $1.0 }
    }
    
    private var maxAmount: Double {
        chartData.map { $0.1 }.max() ?? 0
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Transaction Volume")
                .font(.headline)
            
            if chartData.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: 200)
            } else {
                GeometryReader { geometry in
                    HStack(alignment: .bottom, spacing: 8) {
                        ForEach(chartData, id: \.0) { item in
                            VStack {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.blue)
                                    .frame(height: geometry.size.height * CGFloat(item.1 / maxAmount))
                                
                                Text(item.0)
                                    .font(.caption)
                                    .rotationEffect(.degrees(-45))
                            }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

#if DEBUG
struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        let mockTransactions = [
            Transaction(id: 1, userId: 1, amount: 100, type: .deposit, status: .completed, description: nil, createdAt: Date()),
            Transaction(id: 2, userId: 1, amount: 50, type: .withdrawal, status: .completed, description: nil, createdAt: Date().addingTimeInterval(-3600)),
            Transaction(id: 3, userId: 1, amount: 75, type: .deposit, status: .completed, description: nil, createdAt: Date().addingTimeInterval(-7200))
        ]
        
        ChartView(data: mockTransactions, timeframe: .day)
            .frame(height: 300)
            .padding()
    }
}
#endif
