import SwiftUI
import PhotosUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var manager: ExpenseManager
    
    @State private var amount: String = ""
    @State private var description: String = ""
    @State private var type: TransactionType = .expense
    @State private var category: TransactionCategory = .food
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var imageData: Data? = nil
    @State private var showAlert = false
    
    var categories: [TransactionCategory] {
        type == .expense ? TransactionCategory.expenseCategories : TransactionCategory.incomeCategories
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Tipo", selection: $type) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                .onChange(of: type) { newType in
                    category = newType == .expense ? .food : .salary
                }
                
                TextField("0.00", text: $amount)
                    .keyboardType(.decimalPad)
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(10)
            }
            
            Section("Categoría") {
                Picker("Categoría", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Label(
                            title: { Text(category.rawValue) },
                            icon: { Text(category.icon) }
                        ).tag(category)
                    }
                }
            }
            
            Section("Detalles") {
                TextField("Descripción", text: $description)
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label(
                        title: { Text(imageData == nil ? "Agregar comprobante" : "Cambiar comprobante") },
                        icon: { Image(systemName: "doc.text.viewfinder") }
                    )
                }
                
                if let data = imageData, let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 200)
                        .cornerRadius(8)
                }
            }
        }
        .navigationTitle("Nueva Transacción")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancelar") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Guardar") {
                    guard let value = Double(amount), value > 0 else {
                        showAlert = true
                        return
                    }
                    
                    let transaction = Transaction(
                        id: UUID(),
                        amount: value,
                        category: category,
                        type: type,
                        date: Date(),
                        description: description,
                        imageData: imageData
                    )
                    
                    manager.addTransaction(transaction)
                    dismiss()
                }
                .disabled(amount.isEmpty || description.isEmpty)
            }
        }
        .alert("Monto inválido", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Por favor ingresa un monto válido mayor a 0")
        }
        .onChange(of: selectedItem) { newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    imageData = data
                }
            }
        }
    }
}