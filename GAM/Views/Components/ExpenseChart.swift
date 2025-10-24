import SwiftUI
import Charts

struct ExpenseChart: View {
    let expenses: [Transaction]
    let type: ChartType
    
    enum ChartType {
        case pie
        case bar
        case line
    }
    
    private var categoryData: [(category: TransactionCategory, amount: Double)] {
        Dictionary(grouping: expenses.filter { $0.type == .expense }) { $0.category }
            .map { (category: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.amount > $1.amount }
    }
    
    private var dateData: [(date: Date, amount: Double)] {
        Dictionary(grouping: expenses.filter { $0.type == .expense }) { Calendar.current.startOfDay(for: $0.date) }
            .map { (date: $0.key, amount: $0.value.reduce(0) { $0 + $1.amount }) }
            .sorted { $0.date < $1.date }
    }
    
    var body: some View {
        Group {
            switch type {
            case .pie:
                Chart(categoryData, id: \.category) { item in
                    SectorMark(
                        angle: .value("Monto", item.amount),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Categoría", item.category.rawValue))
                }
                
            case .bar:
                Chart(categoryData, id: \.category) { item in
                    BarMark(
                        x: .value("Categoría", item.category.rawValue),
                        y: .value("Monto", item.amount)
                    )
                    .foregroundStyle(AppTheme.primary)
                }
                
            case .line:
                Chart(dateData, id: \.date) { item in
                    LineMark(
                        x: .value("Fecha", item.date),
                        y: .value("Monto", item.amount)
                    )
                    .foregroundStyle(AppTheme.primary)
                    
                    AreaMark(
                        x: .value("Fecha", item.date),
                        y: .value("Monto", item.amount)
                    )
                    .foregroundStyle(AppTheme.primary.opacity(0.1))
                }
            }
        }
        .frame(height: 200)
        .padding()
        .animation(.spring(), value: expenses)
    }
}