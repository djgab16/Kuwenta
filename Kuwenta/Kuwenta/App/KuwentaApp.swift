import SwiftUI

@main
struct KuwentaApp: App {
    private let persistence = PersistentCloudKitController.shared
    @AppStorage(OnboardingViewModel.completedKey) private var hasOnboarded = false

    var body: some Scene {
        WindowGroup {
            Group {
                if hasOnboarded {
                    RootView()
                } else {
                    OnboardingView()
                }
            }
            .environment(\.managedObjectContext, persistence.viewContext)
            .environment(\.transactionRepository, CoreDataTransactionRepository(context: persistence.viewContext))
            .environment(\.categoryStore, CoreDataCategoryStore(context: persistence.viewContext))
            .tint(Color("PrimaryPurple"))
            .task {
                await persistence.bootstrapIfNeeded()
            }
        }
    }
}
