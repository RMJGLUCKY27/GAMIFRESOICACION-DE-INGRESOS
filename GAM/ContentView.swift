import SwiftUI
import Combine

struct ContentView: View {
    @EnvironmentObject var manager: ExpenseManager
    
    var body: some View {
        MainTabView()
    }
}

#Preview {
    ContentView()
        .environmentObject(ExpenseManager())
}
