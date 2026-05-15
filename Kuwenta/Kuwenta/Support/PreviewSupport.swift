import CoreData
import Foundation
import SwiftUI

/// In-memory stack used by SwiftUI previews and unit tests so we never write
/// fixtures to the user's real database.
enum PreviewSupport {
    static let controller: PersistentCloudKitController = {
        let controller = PersistentCloudKitController.inMemoryForTesting()
        Task { await CategorySeeder.seedIfNeeded(in: controller.newBackgroundContext()) }
        seedSampleTransactions(in: controller.viewContext)
        return controller
    }()

    private static func seedSampleTransactions(in context: NSManagedObjectContext) {
        Task {
            // Wait a beat for category seeding to land before adding tx fixtures.
            try? await Task.sleep(nanoseconds: 200_000_000)
            await context.perform {
                let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
                request.predicate = NSPredicate(format: "code IN %@", ["kainan", "transpo", "padala", "subscriptions"])
                guard let categories = try? context.fetch(request), !categories.isEmpty else { return }

                let samples: [(amount: Decimal, code: String, daysAgo: Int, note: String?)] = [
                    (180, "kainan",        0, "Kape sa Starbucks"),
                    (250, "transpo",       0, "Grab papuntang Makati"),
                    (5_000, "padala",      1, "Padala kay Mama"),
                    (549, "subscriptions", 2, "Netflix renewal")
                ]

                let calendar = Calendar.current
                for sample in samples {
                    guard let category = categories.first(where: { ($0.value(forKey: "code") as? String) == sample.code }) else { continue }
                    let tx = NSEntityDescription.insertNewObject(forEntityName: "Transaction", into: context)
                    tx.setValue(UUID(), forKey: "id")
                    tx.setValue(NSDecimalNumber(decimal: sample.amount), forKey: "amount")
                    tx.setValue("PHP", forKey: "currency")
                    let occurredAt = calendar.date(byAdding: .day, value: -sample.daysAgo, to: Date()) ?? Date()
                    tx.setValue(occurredAt, forKey: "occurredAt")
                    tx.setValue(sample.note, forKey: "note")
                    tx.setValue("preview", forKey: "source")
                    tx.setValue(Date(), forKey: "createdAt")
                    tx.setValue(Date(), forKey: "updatedAt")
                    tx.setValue(category, forKey: "category")
                }
                try? context.save()
            }
        }
    }
}
