import SwiftUI

struct TransactionListView: View {
    @Environment(\.transactionRepository) private var repository
    @State private var viewModel: TransactionsViewModel?
    @State private var showAddSheet = false

    var body: some View {
        List {
            if let viewModel {
                if viewModel.transactions.isEmpty {
                    Text("Wala pang nakatatak. Tap + para magsimula.")
                        .font(KuwentaTypography.body)
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(viewModel.transactions) { tx in
                        TransactionRowView(transaction: tx)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    viewModel.delete(tx.id)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Mga galaw")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet, onDismiss: { viewModel?.reload() }) {
            AddTransactionView()
        }
        .onAppear {
            if viewModel == nil {
                viewModel = TransactionsViewModel(repository: repository)
            }
            viewModel?.reload()
        }
    }
}

#Preview {
    NavigationStack {
        TransactionListView()
    }
    .environment(\.managedObjectContext, PreviewSupport.controller.viewContext)
    .environment(\.transactionRepository, CoreDataTransactionRepository(context: PreviewSupport.controller.viewContext))
    .environment(\.categoryStore, CoreDataCategoryStore(context: PreviewSupport.controller.viewContext))
}
