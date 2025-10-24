import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var manager: ExpenseManager
    var body: some View {
        VStack(spacing: 20) {
            Text("Nivel \(manager.userProfile.level)")
                .font(.largeTitle)
                .bold()
            ProgressBar(value: Double(manager.userProfile.points % 1000), maxValue: 1000)
                .frame(height: 20)
            Text("Puntos: \(manager.userProfile.points)")
                .font(.headline)
            Text("Mejor racha: \(manager.userProfile.bestStreak) días")
            Text("Insignias")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(manager.userProfile.badges) { badge in
                        VStack {
                            Text(badge.icon)
                                .font(.largeTitle)
                            Text(badge.name)
                                .font(.caption)
                            if badge.unlocked {
                                Text("Desbloqueada")
                                    .foregroundColor(.green)
                            } else {
                                Text("Bloqueada")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .transition(.scale)
                        .animation(.spring(), value: badge.unlocked)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle("Perfil")
    }
}

#Preview {
    ProfileView().environmentObject(ExpenseManager())
}
