import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var manager: ExpenseManager
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
            NavigationView {
                AddTransactionView()
            }
            .tabItem {
                Label("Agregar", systemImage: "plus.circle.fill")
            }
            ExpensesListView()
                .tabItem {
                    Label("Gastos", systemImage: "list.bullet")
                }
            ReportsView()
                .tabItem {
                    Label("Reportes", systemImage: "chart.pie.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
        .accentColor(.accentColor)
    }
}

#Preview {
    MainTabView()
        .environmentObject(ExpenseManager())
}
