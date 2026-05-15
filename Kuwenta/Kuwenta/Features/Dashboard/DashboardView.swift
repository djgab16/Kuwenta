import SwiftUI

struct DashboardView: View {
    @Environment(\.transactionRepository) private var repository
    @Environment(\.categoryStore) private var categoryStore
    @State private var viewModel: DashboardViewModel?
    @State private var showAddSheet = false

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                PeraSaBulsaCard(amount: viewModel?.totalThisMonth ?? 0)
                    .padding(.horizontal)

                if let viewModel, !viewModel.topCategories.isEmpty {
                    CategoryChipStrip(items: viewModel.topCategories)
                        .padding(.horizontal)
                }

                RecentTransactionsSection(
                    transactions: viewModel?.recentTransactions ?? []
                )
            }
            .padding(.vertical)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(MonthHelpers.friendlyMonthLabel())
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAddSheet = true
                } label: {
                    Label("Add", systemImage: "plus.circle.fill")
                        .font(.title3)
                }
            }
        }
        .sheet(isPresented: $showAddSheet, onDismiss: { viewModel?.reload() }) {
            AddTransactionView()
        }
        .onAppear {
            if viewModel == nil {
                viewModel = DashboardViewModel(repository: repository, categoryStore: categoryStore)
            }
            viewModel?.reload()
        }
    }
}

private struct RecentTransactionsSection: View {
    let transactions: [TransactionRecord]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Mga huling galaw")
                    .font(KuwentaTypography.sectionTitle)
                Spacer()
                NavigationLink("Lahat") {
                    TransactionListView()
                }
                .font(KuwentaTypography.caption)
            }
            .padding(.horizontal)

            if transactions.isEmpty {
                EmptyStateView()
                    .padding(.horizontal)
            } else {
                VStack(spacing: 0) {
                    ForEach(transactions) { tx in
                        TransactionRowView(transaction: tx)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        if tx.id != transactions.last?.id {
                            Divider().padding(.leading, 60)
                        }
                    }
                }
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
        }
    }
}

private struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text("Wala pang galaw this month.")
                .font(KuwentaTypography.body)
                .foregroundStyle(.secondary)
            Text("Tap + para mag-log ng gastos.")
                .font(KuwentaTypography.caption)
                .foregroundStyle(.tertiary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        DashboardView()
    }
    .environment(\.managedObjectContext, PreviewSupport.controller.viewContext)
    .environment(\.transactionRepository, CoreDataTransactionRepository(context: PreviewSupport.controller.viewContext))
    .environment(\.categoryStore, CoreDataCategoryStore(context: PreviewSupport.controller.viewContext))
}
