import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var manager: ExpenseManager
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("¡Hola, nivel \(manager.userProfile.level)!")
                    .font(.title)
                    .bold()
                Spacer()
                if manager.userProfile.currentStreak > 0 {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.orange)
                        .scaleEffect(1.2)
                        .transition(.scale)
                        .animation(.spring(), value: manager.userProfile.currentStreak)
                }
            }
            HStack {
                VStack {
                    Text("Puntos")
                    Text("\(manager.userProfile.points)")
                        .font(.headline)
                        .foregroundColor(.accentColor)
                }
                Spacer()
                VStack {
                    Text("Mejor racha")
                    Text("\(manager.userProfile.bestStreak) días")
                        .font(.headline)
                }
            }
            ProgressBar(value: Double(manager.userProfile.points % 1000), maxValue: 1000)
                .frame(height: 20)
                .padding(.vertical)
            Text("Transacciones recientes")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(manager.transactions.prefix(5).enumerated()), id: \.element.id) { index, transaction in
                        VStack {
                            Text(transaction.category.icon)
                                .font(.largeTitle)
                            Text("\(transaction.type == .expense ? "-" : "+")\(transaction.amount, specifier: "$%.2f")")
                                .font(.subheadline)
                                .foregroundColor(transaction.type == .expense ? .red : .green)
                            Text(transaction.category.rawValue.capitalized)
                                .font(.caption)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .transition(.asymmetric(insertion: .move(edge: .trailing),
                                              removal: .move(edge: .leading)))
                        .id(transaction.id) // Usar el ID único para la animación
                    }
                }
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: manager.transactions)
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DashboardView().environmentObject(ExpenseManager())
}
