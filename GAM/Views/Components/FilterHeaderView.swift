import SwiftUI

struct FilterHeaderView: View {
    @Binding var selectedType: TransactionType?
    @Binding var selectedCategory: TransactionCategory?
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 15) {
            // Filtro por tipo (Gastos/Ingresos)
            HStack {
                FilterChip(
                    title: "Todos",
                    isSelected: selectedType == nil,
                    icon: "list.bullet"
                ) {
                    withAnimation { selectedType = nil }
                }
                
                ForEach(TransactionType.allCases, id: \.self) { type in
                    FilterChip(
                        title: type.rawValue,
                        isSelected: selectedType == type,
                        icon: type == .expense ? "arrow.down.circle.fill" : "arrow.up.circle.fill"
                    ) {
                        withAnimation { selectedType = type }
                    }
                }
            }
            .padding(.horizontal)
            
            // Barra de búsqueda
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Buscar transacción...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            
            // Categorías
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    CategoryChip(
                        title: "Todas",
                        icon: "🏷️",
                        isSelected: selectedCategory == nil
                    ) {
                        withAnimation { selectedCategory = nil }
                    }
                    
                    let categories = selectedType == .income ? 
                        TransactionCategory.incomeCategories :
                        selectedType == .expense ?
                        TransactionCategory.expenseCategories :
                        TransactionCategory.allCases
                    
                    ForEach(categories, id: \.self) { category in
                        CategoryChip(
                            title: category.rawValue,
                            icon: category.icon,
                            isSelected: selectedCategory == category
                        ) {
                            withAnimation { selectedCategory = category }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .background(Color(UIColor.systemBackground))
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text(title)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.primary : Color.gray.opacity(0.15))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(20)
            .animation(.spring(), value: isSelected)
        }
    }
}

struct CategoryChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(icon)
                Text(title)
                    .font(.subheadline)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? AppTheme.primary.opacity(0.2) : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? AppTheme.primary : .primary)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? AppTheme.primary : Color.clear, lineWidth: 1)
            )
        }
    }
}