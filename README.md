# GAM - Gestión de Gastos y Presupuestos

Una aplicación móvil para iOS desarrollada en SwiftUI que permite a los usuarios gestionar sus gastos, establecer presupuestos y hacer seguimiento de sus hábitos financieros de manera gamificada.

## 📱 Características Principales

### 💰 Gestión de Transacciones
- **Registro de gastos e ingresos** con categorización automática
- **Múltiples categorías** para gastos (comida, transporte, entretenimiento, salud, compras, facturas, otros)
- **Categorías de ingresos** (salario, inversiones, regalos, negocio, freelance)
- **Soporte para imágenes** en las transacciones
- **Descripción detallada** para cada transacción

### 📊 Sistema de Presupuestos
- Creación de presupuestos por categoría
- Seguimiento de gastos vs presupuesto establecido
- Períodos configurables: diario, semanal, mensual, anual
- Alertas cuando se acerca al límite del presupuesto

### 🎮 Gamificación
- **Sistema de puntos** por registrar gastos
- **Niveles de usuario** basados en puntos acumulados
- **Sistema de rachas** para fomentar el uso diario
- **Insignias desbloqueables**:
  - 👣 **Primer Paso**: Registra tu primer gasto (10 puntos)
  - 💰 **Ahorrador**: Mantén gastos bajo presupuesto por una semana (100 puntos)
  - 📊 **Organizado**: Usa todas las categorías (200 puntos)
  - 🏆 **Experto**: Alcanza nivel 10 (1000 puntos)

### 📈 Reportes y Análisis
- Visualización de gastos por categoría
- Gráficos de tendencias temporales
- Análisis de patrones de gasto
- Resumen mensual y anual

### 🔔 Notificaciones
- Recordatorios diarios para registrar gastos (9 PM)
- Mantiene la racha de uso activa
- Notificaciones personalizables

## 🏗️ Arquitectura

### Estructura del Proyecto

```
GAM/
├── GAMApp.swift                 # Punto de entrada de la aplicación
├── ContentView.swift            # Vista principal
├── Models/
│   ├── DataModels.swift         # Modelos de presupuesto, perfil y insignias
│   └── TransactionModels.swift  # Modelos de transacciones y categorías
├── ViewModels/
│   └── ExpenseManager.swift     # Lógica de negocio principal
├── Views/
│   ├── MainTabView.swift        # Navegación principal con tabs
│   ├── DashboardView.swift      # Panel de control principal
│   ├── AddTransactionView.swift # Formulario para agregar transacciones
│   ├── ExpensesListView.swift   # Lista de gastos
│   ├── ReportsView.swift        # Reportes y gráficos
│   ├── ProfileView.swift        # Perfil del usuario
│   ├── BudgetManagementView.swift # Gestión de presupuestos
│   ├── ProgressBar.swift        # Componente de barra de progreso
│   └── Components/
│       ├── ExpenseChart.swift   # Gráficos de gastos
│       └── FilterHeaderView.swift # Filtros de vista
├── Services/
│   ├── NotificationService.swift    # Servicio de notificaciones
│   ├── PersistenceController.swift  # Control de persistencia
│   └── StorageService.swift         # Servicio de almacenamiento
└── Theme/
    └── AppTheme.swift          # Tema y colores de la aplicación
```

### Patrones de Diseño Implementados

#### 🎯 MVVM (Model-View-ViewModel)
```swift
// MODEL: Estructura de datos pura
struct Transaction: Codable {
    let id: UUID
    var amount: Double
    var category: TransactionCategory
}

// VIEWMODEL: Lógica de negocio
class ExpenseManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    func addTransaction(_ transaction: Transaction) {
        // Lógica de negocio aquí
    }
}

// VIEW: Interfaz de usuario
struct TransactionListView: View {
    @ObservableObject var manager: ExpenseManager
    
    var body: some View {
        // Solo UI, sin lógica de negocio
    }
}
```

#### 🔄 Programación Reactiva con Combine
```swift
private func setupSubscriptions() {
    // Observa cambios en transacciones y actualiza automáticamente
    $transactions
        .sink { [weak self] transactions in
            self?.saveTransactions()
            self?.updateStatistics()
        }
        .store(in: &cancellables)
}
```

#### 💉 Dependency Injection
```swift
// Permite cambiar la implementación sin modificar el código
init(storageService: StorageService = LocalStorageService()) {
    self.storageService = storageService
}

// Para testing se puede inyectar un MockStorageService
let manager = ExpenseManager(storageService: MockStorageService())
```

#### 🏭 Factory Pattern para Badges
```swift
private static var defaultBadges: [Badge] = [
    Badge(id: UUID(), name: "Primer Paso", description: "Registra tu primer gasto", 
          pointsRequired: 10, unlocked: false, icon: "👣"),
    // Más badges...
]
```

## � Flujo de Datos y Estados

### Diagrama de Flujo de Datos
```
Usuario Agrega Transacción
        ↓
AddTransactionView (Validación)
        ↓
ExpenseManager.addTransaction()
        ↓
┌─────────────────────┬─────────────────────┬─────────────────────┐
│   Actualizar        │    Actualizar       │    Actualizar       │
│   Transacciones     │    Puntos/Nivel     │    Presupuestos     │
└─────────────────────┴─────────────────────┴─────────────────────┘
        ↓
@Published notifica cambios
        ↓
UI se actualiza automáticamente
```

### Manejo de Estados
```swift
// Estado de carga
@Published var isLoading: Bool = false

// Estado de error
@Published var errorMessage: String?

// Método con manejo de errores
func saveTransaction(_ transaction: Transaction) {
    isLoading = true
    errorMessage = nil
    
    do {
        try storageService.save(transaction)
        transactions.append(transaction)
    } catch {
        errorMessage = "Error al guardar: \(error.localizedDescription)"
    }
    
    isLoading = false
}
```

### Validación de Datos
```swift
private func validateTransaction(_ transaction: Transaction) -> Bool {
    guard transaction.amount > 0 else {
        errorMessage = "El monto debe ser mayor a 0"
        return false
    }
    
    guard !transaction.description.isEmpty else {
        errorMessage = "La descripción es requerida"
        return false
    }
    
    return true
}
```

## �🚀 Tecnologías y Frameworks

- **SwiftUI**: Framework de UI declarativo de Apple para crear interfaces modernas
- **Combine**: Framework de programación reactiva para manejo de eventos asincrónicos
- **UserNotifications**: Sistema de notificaciones locales para recordatorios
- **Foundation**: Funcionalidades base (Date, UUID, Codable, etc.)
- **UIKit** (bridging): Para personalización avanzada de apariencia

## 📲 Funcionalidades de la UI

### 🏠 Dashboard (Inicio)
- Resumen de gastos del mes actual
- Progreso de presupuestos
- Accesos rápidos a funciones principales

### ➕ Agregar Transacción
- Formulario intuitivo para registro
- Selección de categoría con iconos
- Opción de adjuntar imagen
- Validación de campos

### 📋 Lista de Gastos
- Vista completa de todas las transacciones
- Filtros por categoría y fecha
- Búsqueda de transacciones
- Opciones de edición y eliminación

### 📊 Reportes
- Gráficos circulares por categoría
- Tendencias temporales
- Comparativas mensuales
- Análisis de hábitos de gasto

### 👤 Perfil
- Información del usuario
- Sistema de niveles y puntos
- Insignias desbloqueadas
- Configuración de la aplicación

## � Explicación del Código

### 🚀 GAMApp.swift - Punto de Entrada
```swift
@main
struct GAMApp: App {
    @StateObject private var expenseManager = ExpenseManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(expenseManager)
                .onAppear {
                    setupAppearance()
                }
        }
    }
}
```
**Explicación:**
- `@main`: Marca el punto de entrada principal de la aplicación
- `@StateObject`: Crea y mantiene una instancia única del `ExpenseManager` durante toda la vida de la app
- `.environmentObject()`: Inyecta el `ExpenseManager` en toda la jerarquía de vistas para acceso global
- `setupAppearance()`: Configura la apariencia de la UI y solicita permisos de notificaciones

### 🏗️ ExpenseManager.swift - Cerebro de la Aplicación
```swift
final class ExpenseManager: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var budgets: [Budget] = []
    @Published var userProfile: UserProfile
    
    func addTransaction(_ transaction: Transaction) {
        transactions.append(transaction)
        if transaction.type == .expense {
            updatePoints(for: transaction)
            updateStreak()
            updateBudgets(for: transaction)
        }
    }
}
```
**Explicación:**
- `ObservableObject`: Permite que las vistas se actualicen automáticamente cuando cambian los datos
- `@Published`: Notifica a las vistas cuando estas propiedades cambian
- `addTransaction()`: Método principal que agrega transacciones y actualiza el sistema de gamificación
- Sistema reactivo: Cualquier cambio en las propiedades actualiza automáticamente la UI

### 📊 Modelos de Datos

#### Transaction Model
```swift
struct Transaction: Identifiable, Codable, Equatable, Hashable {
    let id: UUID
    var amount: Double
    var category: TransactionCategory
    var type: TransactionType
    var date: Date
    var description: String
    var imageData: Data?
}
```
**Explicación:**
- `Identifiable`: Permite usar la transacción en listas de SwiftUI
- `Codable`: Permite guardar/cargar desde almacenamiento local
- `Equatable & Hashable`: Permite comparar transacciones y usarlas en Sets
- `UUID`: Identificador único para cada transacción

#### Categorías con Iconos
```swift
enum TransactionCategory: String, Codable, CaseIterable {
    case food = "Comida"
    case transport = "Transporte"
    // ...
    
    var icon: String {
        switch self {
        case .food: return "🍔"
        case .transport: return "🚗"
        // ...
        }
    }
}
```
**Explicación:**
- `enum`: Define categorías fijas y tipo-seguras
- `CaseIterable`: Permite iterar sobre todas las categorías
- `icon`: Computed property que asigna emojis a cada categoría para mejor UX

### 🎮 Sistema de Gamificación

#### Actualización de Puntos
```swift
private func updatePoints(for transaction: Transaction) {
    userProfile.points += 10
    
    let newLevel = max(1, userProfile.points / 100)
    if newLevel > userProfile.level {
        userProfile.level = newLevel
        // Desbloquear logros por nivel
    }
}
```
**Explicación:**
- Cada transacción otorga 10 puntos
- Los niveles se calculan dividiendo puntos entre 100
- Sistema automático de progresión que recompensa el uso constante

#### Sistema de Rachas
```swift
private func updateStreak() {
    let today = Calendar.current.startOfDay(for: Date())
    let hasTransactionToday = transactions.contains { transaction in
        Calendar.current.isDate(transaction.date, inSameDayAs: today)
    }
    
    if hasTransactionToday {
        userProfile.currentStreak += 1
        if userProfile.currentStreak > userProfile.bestStreak {
            userProfile.bestStreak = userProfile.currentStreak
        }
    }
}
```
**Explicación:**
- Verifica si hay transacciones en el día actual
- Incrementa la racha diaria si el usuario registró gastos
- Mantiene registro de la mejor racha histórica

### 🔔 Sistema de Notificaciones
```swift
class NotificationService {
    func scheduleReminderNotification() {
        let content = UNMutableNotificationContent()
        content.title = "¡No olvides registrar tus gastos!"
        content.body = "Mantén tu racha diaria registrando tus gastos de hoy"
        
        var dateComponents = DateComponents()
        dateComponents.hour = 21  // 9 PM
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }
}
```
**Explicación:**
- Programa notificaciones diarias a las 9 PM
- Usa `UNCalendarNotificationTrigger` para repetición automática
- Fomenta el hábito diario de registro de gastos

### 🎨 Arquitectura de Vistas

#### MainTabView - Navegación Principal
```swift
struct MainTabView: View {
    @EnvironmentObject var manager: ExpenseManager
    
    var body: some View {
        TabView {
            DashboardView()
                .tabItem { Label("Inicio", systemImage: "house.fill") }
            // ... más tabs
        }
    }
}
```
**Explicación:**
- `@EnvironmentObject`: Accede al ExpenseManager compartido
- `TabView`: Crea navegación por pestañas nativa de iOS
- `Label`: Combina texto e iconos del sistema para consistencia visual

#### Manejo de Estado Reactivo
```swift
struct AddTransactionView: View {
    @EnvironmentObject var manager: ExpenseManager
    @State private var amount = ""
    @State private var selectedCategory = TransactionCategory.other
    
    var body: some View {
        // La UI se actualiza automáticamente cuando cambia el estado
    }
}
```
**Explicación:**
- `@State`: Maneja estado local de la vista
- `@EnvironmentObject`: Accede a datos globales compartidos
- SwiftUI actualiza automáticamente la UI cuando cambia cualquier estado

### 💾 Persistencia de Datos
```swift
protocol StorageService {
    func save<T: Codable>(_ object: T, forKey key: String)
    func load<T: Codable>(_ type: T.Type, forKey key: String) -> T?
}

class LocalStorageService: StorageService {
    func save<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
```
**Explicación:**
- Protocolo `StorageService`: Define interfaz para diferentes tipos de almacenamiento
- Uso de `Codable`: Serialización automática a JSON
- `UserDefaults`: Almacenamiento simple para datos de la app
- Patrón Strategy: Permite cambiar fácilmente el método de almacenamiento

## �🔧 Instalación y Configuración

### Requisitos
- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+

### Instalación
1. Clona el repositorio
```bash
git clone [URL_DEL_REPOSITORIO]
```

2. Abre el proyecto en Xcode
```bash
open GAM.xcodeproj
```

3. Configura el equipo de desarrollo en la pestaña "Signing & Capabilities"

4. Ejecuta el proyecto en el simulador o dispositivo físico

## 📝 Uso

1. **Primer uso**: La aplicación solicitará permisos para notificaciones
2. **Registrar gastos**: Usa el tab "Agregar" para registrar nuevas transacciones
3. **Configurar presupuestos**: Establece límites mensuales por categoría
4. **Revisar progreso**: Consulta el dashboard para ver tu situación financiera
5. **Analizar tendencias**: Usa la sección de reportes para entender tus patrones de gasto

## 🎯 Objetivos del Proyecto

- Fomentar hábitos financieros saludables
- Hacer divertido el seguimiento de gastos mediante gamificación
- Proporcionar insights útiles sobre patrones de gasto
- Facilitar el control de presupuestos personales

## ⚡ Optimizaciones y Mejores Prácticas

### Rendimiento
```swift
// Lazy loading para listas grandes
var expensiveTransactions: [Transaction] {
    transactions.lazy
        .filter { $0.type == .expense }
        .sorted { $0.date > $1.date }
}

// Debouncing para búsquedas
@Published var searchText = ""
private var searchCancellable: AnyCancellable?

init() {
    searchCancellable = $searchText
        .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
        .sink { [weak self] text in
            self?.performSearch(text)
        }
}
```

### Manejo de Memoria
```swift
// Weak references para evitar retain cycles
private var cancellables: Set<AnyCancellable> = Set()

deinit {
    cancellables.removeAll()
}
```

### Testing
```swift
// Protocolo para testing
protocol ExpenseManagerProtocol {
    var transactions: [Transaction] { get }
    func addTransaction(_ transaction: Transaction)
}

// Mock para unit tests
class MockExpenseManager: ExpenseManagerProtocol {
    var transactions: [Transaction] = []
    var addTransactionCalled = false
    
    func addTransaction(_ transaction: Transaction) {
        addTransactionCalled = true
        transactions.append(transaction)
    }
}
```

### Accesibilidad
```swift
// Soporte para VoiceOver y accesibilidad
Button("Agregar Gasto") {
    addTransaction()
}
.accessibilityHint("Abre el formulario para agregar un nuevo gasto")
.accessibilityIdentifier("addExpenseButton")
```

### Localización
```swift
// Textos localizables
Text("expense_amount_title")
    .font(.headline)

// En Localizable.strings:
// "expense_amount_title" = "Monto del Gasto";
```

## 🧪 Testing y Calidad

### Unit Tests
```swift
class ExpenseManagerTests: XCTestCase {
    var manager: ExpenseManager!
    var mockStorage: MockStorageService!
    
    override func setUp() {
        mockStorage = MockStorageService()
        manager = ExpenseManager(storageService: mockStorage)
    }
    
    func testAddTransaction() {
        let transaction = Transaction(...)
        manager.addTransaction(transaction)
        
        XCTAssertEqual(manager.transactions.count, 1)
        XCTAssertTrue(mockStorage.saveCalled)
    }
}
```

### Arquitectura Testeable
- **Dependency Injection**: Permite inyectar mocks
- **Protocolos**: Abstraen dependencias externas
- **Pure Functions**: Funciones sin efectos secundarios
- **Separation of Concerns**: Cada clase tiene una responsabilidad única

## 🔮 Funcionalidades Futuras

### Próximas Versiones
- **v2.0**: Sincronización en la nube con CloudKit
- **v2.1**: Categorías personalizadas definidas por el usuario
- **v2.2**: Exportación de datos (PDF, CSV, Excel)
- **v3.0**: Integración con bancos via Open Banking
- **v3.1**: Recordatorios inteligentes de facturas recurrentes
- **v3.2**: Metas de ahorro con tracking automático

### Integraciones Planeadas
- **Machine Learning**: Análisis predictivo de gastos
- **Widgets iOS**: Resumen en pantalla de inicio
- **Shortcuts de Siri**: Control por voz
- **Apple Pay**: Importación automática de transacciones
- **HealthKit**: Correlación entre gastos de salud y datos de salud

## 📄 Licencia

[Especificar la licencia del proyecto]

## 👥 Contribuciones

Las contribuciones son bienvenidas. Por favor:
1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📞 Contacto

[Información de contacto del desarrollador]

---

⭐ Si te gusta este proyecto, ¡no olvides darle una estrella!
