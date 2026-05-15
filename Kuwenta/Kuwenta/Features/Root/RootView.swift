import SwiftUI

struct RootView: View {
    @State private var selectedTab: Tab = .dashboard

    enum Tab: Hashable {
        case dashboard, transactions, settings
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                DashboardView()
            }
            .tabItem { Label("Bahay", systemImage: "house.fill") }
            .tag(Tab.dashboard)

            NavigationStack {
                TransactionListView()
            }
            .tabItem { Label("Galaw", systemImage: "list.bullet.rectangle") }
            .tag(Tab.transactions)

            NavigationStack {
                SettingsView()
            }
            .tabItem { Label("Settings", systemImage: "gear") }
            .tag(Tab.settings)
        }
    }
}

#Preview {
    RootView()
        .environment(\.managedObjectContext, PreviewSupport.controller.viewContext)
        .environment(\.transactionRepository, CoreDataTransactionRepository(context: PreviewSupport.controller.viewContext))
        .environment(\.categoryStore, CoreDataCategoryStore(context: PreviewSupport.controller.viewContext))
}
