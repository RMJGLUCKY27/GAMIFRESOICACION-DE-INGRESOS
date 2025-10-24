import SwiftUI

struct AppTheme {
    static let primary = Color("AccentColor")
    static let secondary = Color.orange
    static let background = Color(UIColor.systemBackground)
    static let secondaryBackground = Color(UIColor.secondarySystemBackground)
    static let text = Color.primary
    static let secondaryText = Color.secondary
    static let success = Color.green
    static let error = Color.red
    static let warning = Color.yellow
    
    struct CardStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .padding()
                .background(AppTheme.background)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
    }
    
    struct AnimatedButton: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .padding()
                .background(AppTheme.primary)
                .foregroundColor(.white)
                .cornerRadius(10)
                .scaleEffect(configuration.isPressed ? 0.95 : 1)
                .animation(.spring(), value: configuration.isPressed)
        }
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(AppTheme.CardStyle())
    }
}