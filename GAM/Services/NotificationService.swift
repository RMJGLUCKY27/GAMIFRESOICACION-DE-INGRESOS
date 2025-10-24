import Foundation
import UserNotifications

class NotificationService {
    static let shared = NotificationService()
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notificaciones autorizadas")
            } else if let error = error {
                print("Error solicitando autorización: \(error)")
            }
        }
    }
    
    func scheduleReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "¡No olvides registrar tus gastos!"
        content.body = "Mantén tu racha diaria registrando tus gastos de hoy"
        content.sound = .default
        
        // Programar para las 9 PM todos los días
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "dailyReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleBudgetAlertNotification(category: TransactionCategory, spent: Double, limit: Double) {
        guard spent >= limit * 0.8 else { return } // Alertar cuando se alcanza el 80% del presupuesto
        
        let content = UNMutableNotificationContent()
        content.title = "¡Alerta de Presupuesto!"
        content.body = "Has alcanzado el \(Int(spent/limit * 100))% de tu presupuesto en \(category.rawValue)"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: "budgetAlert-\(category.rawValue)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
}