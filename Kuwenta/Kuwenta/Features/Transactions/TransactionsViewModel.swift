import Foundation
import Observation

@Observable
final class TransactionsViewModel {
    private let repository: TransactionRepository

    var transactions: [TransactionRecord] = []
    var errorMessage: String?

    init(repository: TransactionRepository) {
        self.repository = repository
    }

    func reload() {
        do {
            transactions = try repository.recentTransactions(limit: 200)
            errorMessage = nil
        } catch {
            errorMessage = "Hindi ma-load ang mga galaw mo. Subukan ulit?"
        }
    }

    func delete(_ id: UUID) {
        do {
            try repository.delete(id: id)
            reload()
        } catch {
            errorMessage = "Hindi ma-delete ngayon. Subukan ulit mamaya."
        }
    }
}

@Observable
final class AddTransactionViewModel {
    private let repository: TransactionRepository
    private let categoryStore: CategoryStore

    var amountString: String = ""
    var note: String = ""
    var occurredAt: Date = Date()
    var selectedCategoryCode: String?
    var categories: [CategoryRecord] = []
    var errorMessage: String?
    var didSave: Bool = false

    init(repository: TransactionRepository, categoryStore: CategoryStore) {
        self.repository = repository
        self.categoryStore = categoryStore
    }

    func loadCategories() {
        categories = (try? categoryStore.allCategories()) ?? []
        if selectedCategoryCode == nil {
            selectedCategoryCode = categories.first?.code
        }
    }

    var canSave: Bool {
        guard let amount = parseAmount(), amount > 0 else { return false }
        return selectedCategoryCode != nil
    }

    func save() {
        guard let amount = parseAmount(), let code = selectedCategoryCode else {
            errorMessage = "Lagyan ng amount at category bago i-save."
            return
        }
        do {
            try repository.add(
                amount: amount,
                categoryCode: code,
                occurredAt: occurredAt,
                note: note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : note
            )
            didSave = true
        } catch {
            errorMessage = "Hindi na-save. Subukan ulit."
        }
    }

    private func parseAmount() -> Decimal? {
        let cleaned = amountString
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "₱", with: "")
            .trimmingCharacters(in: .whitespaces)
        guard !cleaned.isEmpty else { return nil }
        return Decimal(string: cleaned)
    }
}
