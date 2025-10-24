import Foundation
import SwiftUI
import Combine

final class ExpenseManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var budgets: [Budget] = []
    @Published var userProfile: UserProfile
    
    private let storageService: StorageService
    private var cancellables: Set<AnyCancellable>
    
    static let shared = ExpenseManager()
    
    init(storageService: StorageService = LocalStorageService()) {
        self.storageService = storageService
        self.userProfile = UserProfile(points: 0, level: 1, badges: Self.defaultBadges, currentStreak: 0, bestStreak: 0)
        self.cancellables = Set<AnyCancellable>()
        
        loadData()
        setupSubscriptions()
    }
    
    private static var defaultBadges: [Badge] = [
        Badge(id: UUID(), name: "Primer Paso", description: "Registra tu primer gasto", pointsRequired: 10, unlocked: false, icon: "👣"),
        Badge(id: UUID(), name: "Ahorrador", description: "Mantén gastos bajo presupuesto por una semana", pointsRequired: 100, unlocked: false, icon: "💰"),
        Badge(id: UUID(), name: "Organizado", description: "Usa todas las categorías", pointsRequired: 200, unlocked: false, icon: "📊"),
        Badge(id: UUID(), name: "Experto", description: "Alcanza nivel 10", pointsRequired: 1000, unlocked: false, icon: "🏆")
    ]
    
    // MARK: - Expense Methods
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        if transaction.type == .expense {
            updatePoints(for: transaction)
            updateStreak()
            updateBudgets(for: transaction)
        }
    }
    
    func removeTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
        if transaction.type == .expense {
            updateBudgets(for: transaction)
        }
    }

    func transactions(for category: TransactionCategory, type: TransactionType) -> [Transaction] {
        transactions.filter { $0.category == category && $0.type == type }
    }    // MARK: - Budget Methods
    func addBudget(_ budget: Budget) {
        budgets.append(budget)
    }
    
    private func updateBudgets(for transaction: Transaction) {
        if transaction.type == .expense,
           let index = budgets.firstIndex(where: { $0.category == transaction.category }) {
            budgets[index].spent += transaction.amount
        }
    }
    
    // MARK: - Gamification
    private func updatePoints(for transaction: Transaction) {
        if transaction.type == .expense {
            userProfile.points += 10
            userProfile.level = userProfile.points / 1000 + 1
            checkBadges()
        }
    }
    
    func updateStreak() {
        // Lógica para actualizar racha diaria
        userProfile.currentStreak += 1
        if userProfile.currentStreak > userProfile.bestStreak {
            userProfile.bestStreak = userProfile.currentStreak
        }
    }
    
    private func checkBadges() {
        let unlockedBadges = userProfile.badges.filter { !$0.unlocked }
        for var badge in unlockedBadges {
            switch badge.name {
            case "Primer Paso":
                badge.unlocked = !transactions.filter { $0.type == .expense }.isEmpty
                
            case "Ahorrador":
                if let weekTransactions = lastWeekTransactions() {
                    let expenseTransactions = weekTransactions.filter { $0.type == .expense }
                    badge.unlocked = expenseTransactions.allSatisfy { transaction in
                        guard let budget = budgets.first(where: { $0.category == transaction.category }) else { return true }
                        return budget.spent <= budget.limit
                    }
                }
                
            case "Organizado":
                let usedCategories = Set(transactions.filter { $0.type == .expense }.map { $0.category })
                badge.unlocked = usedCategories.count == TransactionCategory.expenseCategories.count
                
            case "Experto":
                badge.unlocked = userProfile.level >= 10
                
            default:
                break
            }
            
            if badge.unlocked {
                if let index = userProfile.badges.firstIndex(where: { $0.id == badge.id }) {
                    userProfile.badges[index] = badge
                    userProfile.points += badge.pointsRequired
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func lastWeekTransactions() -> [Transaction]? {
        let calendar = Calendar.current
        guard let oneWeekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) else { return nil }
        return transactions.filter { $0.date >= oneWeekAgo }
    }
    
    // MARK: - Persistence
    private func loadData() {
        do {
            transactions = try storageService.load(forKey: "transactions")
            budgets = try storageService.load(forKey: "budgets")
            userProfile = try storageService.load(forKey: "userProfile")
        } catch {
            print("Error loading data: \(error)")
            // Use default values if no data is found
        }
    }
    
    private func saveData() {
        do {
            try storageService.save(transactions, forKey: "transactions")
            try storageService.save(budgets, forKey: "budgets")
            try storageService.save(userProfile, forKey: "userProfile")
        } catch {
            print("Error saving data: \(error)")
        }
    }
    
    private func setupSubscriptions() {
        // Observe changes in published properties and save them
        $transactions
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveData()
            }
            .store(in: &cancellables)
        
        $budgets
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveData()
            }
            .store(in: &cancellables)
        
        $userProfile
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.saveData()
            }
            .store(in: &cancellables)
    }
}
