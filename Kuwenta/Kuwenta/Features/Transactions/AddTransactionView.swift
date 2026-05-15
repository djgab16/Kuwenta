import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.transactionRepository) private var repository
    @Environment(\.categoryStore) private var categoryStore
    @State private var viewModel: AddTransactionViewModel?
    @FocusState private var amountFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                if let viewModel {
                    Section("Magkano?") {
                        HStack {
                            Text("₱")
                                .font(KuwentaTypography.displayAmount)
                                .foregroundStyle(.secondary)
                            TextField("0", text: Binding(
                                get: { viewModel.amountString },
                                set: { viewModel.amountString = $0 }
                            ))
                            .keyboardType(.decimalPad)
                            .font(KuwentaTypography.displayAmount)
                            .focused($amountFocused)
                        }
                    }

                    Section("Saan napunta?") {
                        CategoryPickerView(
                            categories: viewModel.categories,
                            selection: Binding(
                                get: { viewModel.selectedCategoryCode },
                                set: { viewModel.selectedCategoryCode = $0 }
                            )
                        )
                    }

                    Section("Details") {
                        DatePicker("Kailan", selection: Binding(
                            get: { viewModel.occurredAt },
                            set: { viewModel.occurredAt = $0 }
                        ))
                        TextField("Note (optional, e.g. Jollibee with tropa)", text: Binding(
                            get: { viewModel.note },
                            set: { viewModel.note = $0 }
                        ), axis: .vertical)
                        .lineLimit(1...3)
                    }

                    if let message = viewModel.errorMessage {
                        Section {
                            Text(message)
                                .foregroundStyle(KuwentaColor.dangerRed)
                        }
                    }
                }
            }
            .navigationTitle("Mag-log ng gastos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel?.save()
                    }
                    .disabled(!(viewModel?.canSave ?? false))
                }
            }
            .onAppear {
                if viewModel == nil {
                    viewModel = AddTransactionViewModel(repository: repository, categoryStore: categoryStore)
                }
                viewModel?.loadCategories()
                amountFocused = true
            }
            .onChange(of: viewModel?.didSave ?? false) { _, didSave in
                if didSave { dismiss() }
            }
        }
    }
}

#Preview {
    AddTransactionView()
        .environment(\.managedObjectContext, PreviewSupport.controller.viewContext)
        .environment(\.transactionRepository, CoreDataTransactionRepository(context: PreviewSupport.controller.viewContext))
        .environment(\.categoryStore, CoreDataCategoryStore(context: PreviewSupport.controller.viewContext))
}
