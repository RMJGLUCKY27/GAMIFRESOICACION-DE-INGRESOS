import SwiftUI

struct ExpensesListView: View {
    @EnvironmentObject var manager: ExpenseManager
    @State private var selectedType: TransactionType? = nil
    @State private var selectedCategory: TransactionCategory? = nil
    @State private var searchText: String = ""
    @State private var showingAddTransaction = false
    
    var filteredTransactions: [Transaction] {
        manager.transactions.filter { transaction in
            // Filtro por tipo
            let typeMatch = selectedType == nil || transaction.type == selectedType
            // Filtro por categoría
            let categoryMatch = selectedCategory == nil || transaction.category == selectedCategory
            // Filtro por texto
            let textMatch = searchText.isEmpty || 
                          transaction.description.localizedCaseInsensitiveContains(searchText) ||
                          transaction.category.rawValue.localizedCaseInsensitiveContains(searchText)
            
            return typeMatch && categoryMatch && textMatch
        }
        .sorted { $0.date > $1.date }
    }
    
    var totalBalance: Double {
        manager.transactions.reduce(0) { sum, transaction in
            sum + (transaction.type == .income ? transaction.amount : -transaction.amount)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Balance Card
            VStack {
                Text("Balance Total")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text("$\(totalBalance, specifier: "%.2f")")
                    .font(.title)
                    .bold()
                    .foregroundColor(totalBalance >= 0 ? .green : .red)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(UIColor.secondarySystemBackground))
            
            // Filtros
            FilterHeaderView(
                selectedType: $selectedType,
                selectedCategory: $selectedCategory,
                searchText: $searchText
            )
            .background(Color(UIColor.systemBackground))
            .shadow(color: Color.black.opacity(0.05), radius: 5, y: 5)
            
            // Lista de transacciones
            List {
                ForEach(filteredTransactions) { transaction in
                    TransactionRow(transaction: transaction)
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                manager.removeTransaction(transaction)
                            } label: {
                                Label("Eliminar", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Transacciones")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddTransaction = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            NavigationView {
                AddTransactionView()
            }
        }
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Icono
            ZStack {
                Circle()
                    .fill(transaction.type == .income ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 44, height: 44)
                Text(transaction.category.icon)
            }
            
            // Detalles
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.description)
                    .font(.headline)
                Text(transaction.category.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Monto
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(transaction.type == .income ? .green : .red)
                Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ExpensesListView().environmentObject(ExpenseManager())
}
