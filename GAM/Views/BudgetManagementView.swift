import SwiftUI

struct BudgetManagementView: View {
    @EnvironmentObject var manager: ExpenseManager
    @State private var selectedCategory: TransactionCategory = .food
    @State private var limit: String = ""
    @State private var period: BudgetPeriod = .monthly
    
    var body: some View {
        VStack {
            Form {
                Picker("Categoría", selection: $selectedCategory) {
                    ForEach(TransactionCategory.expenseCategories, id: \.self) { cat in
                        Text(cat.icon + " " + cat.rawValue.capitalized).tag(cat)
                    }
                }
                TextField("Límite", text: $limit)
                    .keyboardType(.decimalPad)
                Picker("Período", selection: $period) {
                    ForEach(BudgetPeriod.allCases) { p in
                        Text(p.rawValue.capitalized).tag(p)
                    }
                }
                Button("Agregar Presupuesto") {
                    guard let value = Double(limit), value > 0 else { return }
                    let budget = Budget(id: UUID(), category: selectedCategory, limit: value, period: period, spent: 0)
                    manager.addBudget(budget)
                    limit = ""
                }
            }
            List {
                ForEach(manager.budgets) { budget in
                    VStack(alignment: .leading) {
                        Text(budget.category.icon + " " + budget.category.rawValue.capitalized)
                        ProgressBar(value: budget.spent, maxValue: budget.limit)
                            .frame(height: 10)
                        Text("Gastado: $\(budget.spent, specifier: "%.2f") / $\(budget.limit, specifier: "%.2f")")
                            .font(.caption)
                        if budget.spent > budget.limit {
                            Text("¡Excedido!")
                                .foregroundColor(.red)
                                .bold()
                                .transition(.opacity)
                                .animation(.easeInOut, value: budget.spent)
                        }
                    }
                }
                .onDelete { indexSet in
                    indexSet.forEach { idx in
                        manager.budgets.remove(at: idx)
                    }
                }
            }
        }
        .navigationTitle("Presupuestos")
    }
}

#Preview {
    BudgetManagementView().environmentObject(ExpenseManager())
}
