import Foundation
import Observation

@Observable
final class DashboardViewModel {
    private let repository: TransactionRepository
    private let categoryStore: CategoryStore

    var totalThisMonth: Decimal = 0
    var recentTransactions: [TransactionRecord] = []
    var topCategories: [CategoryTotal] = []

    struct CategoryTotal: Identifiable, Hashable {
        let id: String
        let name: String
        let icon: String
        let colorAsset: String
        let total: Decimal

        var displayTotal: String { CurrencyFormatter.compact(total) }
    }

    init(repository: TransactionRepository, categoryStore: CategoryStore) {
        self.repository = repository
        self.categoryStore = categoryStore
    }

    func reload() {
        do {
            totalThisMonth = try repository.totalSpentThisMonth()
            recentTransactions = try repository.recentTransactions(limit: 6)

            let categories = (try? categoryStore.allCategories()) ?? []
            let totals = (try? repository.totalsByCategoryThisMonth()) ?? []
            let lookup = Dictionary(uniqueKeysWithValues: categories.map { ($0.code, $0) })

            topCategories = totals.prefix(4).compactMap { entry in
                guard let category = lookup[entry.code] else { return nil }
                return CategoryTotal(
                    id: category.code,
                    name: category.name,
                    icon: category.iconSystemName,
                    colorAsset: category.colorAssetName,
                    total: entry.total
                )
            }
        } catch {
            assertionFailure("Kuwenta dashboard reload failed: \(error)")
        }
    }
}
