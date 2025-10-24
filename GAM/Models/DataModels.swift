import Foundation
import SwiftUI

struct Budget: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var category: TransactionCategory
    var limit: Double
    var period: BudgetPeriod
    var spent: Double
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable conformance
    static func == (lhs: Budget, rhs: Budget) -> Bool {
        lhs.id == rhs.id
    }
}

enum BudgetPeriod: String, Codable, CaseIterable, Identifiable {
    case daily, weekly, monthly, yearly
    var id: String { self.rawValue }
}

struct UserProfile: Codable, Equatable, Hashable {
    var points: Int
    var level: Int
    var badges: [Badge]
    var currentStreak: Int
    var bestStreak: Int
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(points)
        hasher.combine(level)
        hasher.combine(badges)
        hasher.combine(currentStreak)
        hasher.combine(bestStreak)
    }
}

struct Badge: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var pointsRequired: Int
    var unlocked: Bool
    var icon: String
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    // Equatable conformance
    static func == (lhs: Badge, rhs: Badge) -> Bool {
        lhs.id == rhs.id
    }
}
