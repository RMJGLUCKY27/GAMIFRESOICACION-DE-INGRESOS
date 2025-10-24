// GAMApp.swift
import SwiftUI

@main
struct GAMApp: App {
    @StateObject private var expenseManager = ExpenseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseManager)
                .onAppear {
                    // Configuración inicial de la app
                    setupAppearance()
                }
        }
    }
    
    private func setupAppearance() {
        // Personalizar la apariencia de la app
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
        
        // Configurar la apariencia de la navegación
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        
        // Solicitar permisos de notificaciones
        NotificationService.shared.requestAuthorization()
        NotificationService.shared.scheduleReminderNotification()
    }
}
