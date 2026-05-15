import CoreData
import Foundation
import SwiftUI

/// Domain-level value type. Kept separate from the NSManagedObject so view
/// models never leak Core Data into the UI layer.
struct TransactionRecord: Identifiable, Hashable {
    let id: UUID
    var amount: Decimal
    var occurredAt: Date
    var note: String?
    var source: String
    var categoryCode: String
    var categoryName: String
    var categoryIcon: String
    var categoryColorAsset: String
}

protocol TransactionRepository {
    func recentTransactions(limit: Int) throws -> [TransactionRecord]
    func transactionsThisMonth() throws -> [TransactionRecord]
    func totalSpentThisMonth() throws -> Decimal
    func totalsByCategoryThisMonth() throws -> [(code: String, total: Decimal)]
    func add(amount: Decimal, categoryCode: String, occurredAt: Date, note: String?) throws
    func delete(id: UUID) throws
}

final class CoreDataTransactionRepository: TransactionRepository {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func recentTransactions(limit: Int) throws -> [TransactionRecord] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        request.sortDescriptors = [NSSortDescriptor(key: "occurredAt", ascending: false)]
        request.fetchLimit = limit
        request.relationshipKeyPathsForPrefetching = ["category"]
        let results = try context.fetch(request)
        return results.compactMap(Self.map)
    }

    func transactionsThisMonth() throws -> [TransactionRecord] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        let interval = MonthHelpers.currentMonthInterval()
        request.predicate = NSPredicate(
            format: "occurredAt >= %@ AND occurredAt < %@",
            interval.start as NSDate,
            interval.end as NSDate
        )
        request.sortDescriptors = [NSSortDescriptor(key: "occurredAt", ascending: false)]
        request.relationshipKeyPathsForPrefetching = ["category"]
        return try context.fetch(request).compactMap(Self.map)
    }

    func totalSpentThisMonth() throws -> Decimal {
        try transactionsThisMonth().reduce(Decimal(0)) { $0 + $1.amount }
    }

    func totalsByCategoryThisMonth() throws -> [(code: String, total: Decimal)] {
        let transactions = try transactionsThisMonth()
        var totals: [String: Decimal] = [:]
        for tx in transactions {
            totals[tx.categoryCode, default: 0] += tx.amount
        }
        return totals
            .map { (code: $0.key, total: $0.value) }
            .sorted { $0.total > $1.total }
    }

    func add(amount: Decimal, categoryCode: String, occurredAt: Date, note: String?) throws {
        let category = try fetchCategory(code: categoryCode)
        let transaction = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context)
        let now = Date()
        transaction.setValue(UUID(), forKey: "id")
        transaction.setValue(NSDecimalNumber(decimal: amount), forKey: "amount")
        transaction.setValue("PHP", forKey: "currency")
        transaction.setValue(occurredAt, forKey: "occurredAt")
        transaction.setValue(note, forKey: "note")
        transaction.setValue("manual", forKey: "source")
        transaction.setValue(now, forKey: "createdAt")
        transaction.setValue(now, forKey: "updatedAt")
        transaction.setValue(category, forKey: "category")
        try context.save()
    }

    func delete(id: UUID) throws {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Transaction")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        if let object = try context.fetch(request).first {
            context.delete(object)
            try context.save()
        }
    }

    private func fetchCategory(code: String) throws -> NSManagedObject {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
        request.predicate = NSPredicate(format: "code == %@", code)
        request.fetchLimit = 1
        guard let category = try context.fetch(request).first else {
            throw NSError(
                domain: "Kuwenta.TransactionRepository",
                code: 404,
                userInfo: [NSLocalizedDescriptionKey: "Wala pang category na '\(code)'."]
            )
        }
        return category
    }

    private static func map(_ object: NSManagedObject) -> TransactionRecord? {
        guard
            let id = object.value(forKey: "id") as? UUID,
            let amount = (object.value(forKey: "amount") as? NSDecimalNumber)?.decimalValue,
            let occurredAt = object.value(forKey: "occurredAt") as? Date,
            let category = object.value(forKey: "category") as? NSManagedObject,
            let categoryCode = category.value(forKey: "code") as? String,
            let categoryName = category.value(forKey: "name") as? String
        else {
            return nil
        }

        return TransactionRecord(
            id: id,
            amount: amount,
            occurredAt: occurredAt,
            note: object.value(forKey: "note") as? String,
            source: (object.value(forKey: "source") as? String) ?? "manual",
            categoryCode: categoryCode,
            categoryName: categoryName,
            categoryIcon: (category.value(forKey: "iconSystemName") as? String) ?? "circle",
            categoryColorAsset: (category.value(forKey: "colorAssetName") as? String) ?? "PrimaryPurple"
        )
    }
}

private struct TransactionRepositoryKey: EnvironmentKey {
    static let defaultValue: TransactionRepository = CoreDataTransactionRepository(
        context: PersistentCloudKitController.shared.viewContext
    )
}

extension EnvironmentValues {
    var transactionRepository: TransactionRepository {
        get { self[TransactionRepositoryKey.self] }
        set { self[TransactionRepositoryKey.self] = newValue }
    }
}
