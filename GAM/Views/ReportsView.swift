import SwiftUI

struct ReportsView: View {
    @EnvironmentObject var manager: ExpenseManager
    @State private var selectedPeriod: BudgetPeriod = .monthly
    
    var filteredTransactions: [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        
        let periodTransactions = { (date: Date) -> [Transaction] in
            manager.transactions.filter { transaction in
                transaction.type == .expense && transaction.date >= date
            }
        }
        
        switch selectedPeriod {
        case .daily:
            return manager.transactions.filter {
                $0.type == .expense && calendar.isDate($0.date, inSameDayAs: now)
            }
        case .weekly:
            guard let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) else { return [] }
            return periodTransactions(weekAgo)
        case .monthly:
            guard let monthAgo = calendar.date(byAdding: .month, value: -1, to: now) else { return [] }
            return periodTransactions(monthAgo)
        case .yearly:
            guard let yearAgo = calendar.date(byAdding: .year, value: -1, to: now) else { return [] }
            return periodTransactions(yearAgo)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Picker("Período", selection: $selectedPeriod) {
                    ForEach(BudgetPeriod.allCases) { period in
                        Text(period.rawValue.capitalized).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Gráfico de pastel por categorías
                VStack(alignment: .leading) {
                    Text("Distribución por Categorías")
                        .font(.headline)
                    ExpenseChart(expenses: filteredTransactions, type: .pie)
                }
                .cardStyle()
                
                // Gráfico de barras por categorías
                VStack(alignment: .leading) {
                    Text("Gastos por Categoría")
                        .font(.headline)
                    ExpenseChart(expenses: filteredTransactions, type: .bar)
                }
                .cardStyle()
                
                // Gráfico de línea temporal
                VStack(alignment: .leading) {
                    Text("Tendencia de Gastos")
                        .font(.headline)
                    ExpenseChart(expenses: filteredTransactions, type: .line)
                }
                .cardStyle()
                
                // Resumen estadístico
                VStack(alignment: .leading, spacing: 10) {
                    Text("Resumen")
                        .font(.headline)
                    
                    let total = filteredTransactions.reduce(0) { $0 + $1.amount }
                    let avg = filteredTransactions.isEmpty ? 0 : total / Double(filteredTransactions.count)
                    
                    HStack {
                        StatView(title: "Total", value: String(format: "$%.2f", total))
                        StatView(title: "Promedio", value: String(format: "$%.2f", avg))
                        StatView(title: "Cantidad", value: "\(filteredTransactions.count)")
                    }
                }
                .cardStyle()
            }
            .padding()
        }
        .navigationTitle("Reportes")
        .animation(.spring(), value: selectedPeriod)
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppTheme.secondaryBackground)
        .cornerRadius(10)
    }
}

#Preview {
    ReportsView().environmentObject(ExpenseManager())
}
