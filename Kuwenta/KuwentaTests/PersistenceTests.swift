import XCTest
import CoreData
@testable import Kuwenta

final class PersistenceTests: XCTestCase {
    func testCategorySeederIsIdempotent() async throws {
        let controller = PersistentCloudKitController.inMemoryForTesting()
        let context = controller.newBackgroundContext()

        await CategorySeeder.seedIfNeeded(in: context)
        let firstCount = try await count(in: context, entity: "Category")

        await CategorySeeder.seedIfNeeded(in: context)
        let secondCount = try await count(in: context, entity: "Category")

        XCTAssertGreaterThan(firstCount, 0)
        XCTAssertEqual(firstCount, secondCount)
    }

    func testAddTransactionUpdatesMonthlyTotal() async throws {
        let controller = PersistentCloudKitController.inMemoryForTesting()
        await CategorySeeder.seedIfNeeded(in: controller.newBackgroundContext())

        let repo = CoreDataTransactionRepository(context: controller.viewContext)
        try repo.add(amount: 250, categoryCode: "transpo", occurredAt: Date(), note: "Grab")
        try repo.add(amount: 180, categoryCode: "kainan", occurredAt: Date(), note: "Kape")

        let total = try repo.totalSpentThisMonth()
        XCTAssertEqual(total, 430)
    }

    func testTotalsByCategorySortedDescending() async throws {
        let controller = PersistentCloudKitController.inMemoryForTesting()
        await CategorySeeder.seedIfNeeded(in: controller.newBackgroundContext())

        let repo = CoreDataTransactionRepository(context: controller.viewContext)
        try repo.add(amount: 100, categoryCode: "kainan", occurredAt: Date(), note: nil)
        try repo.add(amount: 500, categoryCode: "padala", occurredAt: Date(), note: nil)
        try repo.add(amount: 50,  categoryCode: "transpo", occurredAt: Date(), note: nil)

        let totals = try repo.totalsByCategoryThisMonth()
        XCTAssertEqual(totals.first?.code, "padala")
        XCTAssertEqual(totals.first?.total, 500)
    }

    private func count(in context: NSManagedObjectContext, entity: String) async throws -> Int {
        try await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: entity)
            return try context.count(for: request)
        }
    }
}
