import Foundation
import SwiftUI

enum TransactionType: String, Codable, CaseIterable {
    case expense = "Gasto"
    case income = "Ingreso"
}

struct Transaction: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var amount: Double
    var category: TransactionCategory
    var type: TransactionType
    var date: Date
    var description: String
    var imageData: Data?
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        lhs.id == rhs.id
    }
}

enum TransactionCategory: String, Codable, CaseIterable, Identifiable {
    // Gastos
    case food = "Comida"
    case transport = "Transporte"
    case entertainment = "Entretenimiento"
    case health = "Salud"
    case shopping = "Compras"
    case bills = "Facturas"
    case other = "Otros"
    
    // Ingresos
    case salary = "Salario"
    case investment = "Inversiones"
    case gift = "Regalos"
    case business = "Negocio"
    case freelance = "Freelance"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        // Gastos
        case .food: return "🍔"
        case .transport: return "🚗"
        case .entertainment: return "🎮"
        case .health: return "💊"
        case .shopping: return "🛒"
        case .bills: return "💡"
        case .other: return "📦"
        // Ingresos
        case .salary: return "💰"
        case .investment: return "📈"
        case .gift: return "🎁"
        case .business: return "💼"
        case .freelance: return "💻"
        }
    }
    
    static var expenseCategories: [TransactionCategory] {
        [.food, .transport, .entertainment, .health, .shopping, .bills, .other]
    }
    
    static var incomeCategories: [TransactionCategory] {
        [.salary, .investment, .gift, .business, .freelance]
    }
}