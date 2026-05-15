import CoreData
import Foundation

/// Seeds the Pinoy-default categories on first launch.
/// Categories are addressed by stable `code` keys so future migrations
/// (renaming labels, swapping icons) don't lose links to existing transactions.
enum CategorySeeder {
    struct Seed {
        let code: String
        let name: String
        let symbol: String
        let colorAsset: String
        let sortOrder: Int16
    }

    /// Order here is the order users see in pickers and chips.
    static let seeds: [Seed] = [
        .init(code: "kainan",        name: "Kainan",        symbol: "fork.knife",          colorAsset: "AccentCoral",   sortOrder: 0),
        .init(code: "transpo",       name: "Transpo",       symbol: "car.fill",            colorAsset: "PrimaryPurple", sortOrder: 1),
        .init(code: "groceries",     name: "Groceries",     symbol: "cart.fill",           colorAsset: "SuccessGreen",  sortOrder: 2),
        .init(code: "bills",         name: "Bills",         symbol: "doc.text.fill",       colorAsset: "WarningAmber",  sortOrder: 3),
        .init(code: "utilities",     name: "Utilities",     symbol: "bolt.fill",           colorAsset: "WarningAmber",  sortOrder: 4),
        .init(code: "subscriptions", name: "Subscriptions", symbol: "rectangle.stack",     colorAsset: "PrimaryPurple", sortOrder: 5),
        .init(code: "padala",        name: "Padala",        symbol: "paperplane.fill",     colorAsset: "AccentCoral",   sortOrder: 6),
        .init(code: "baon",          name: "Baon",          symbol: "backpack.fill",       colorAsset: "SuccessGreen",  sortOrder: 7),
        .init(code: "libre",         name: "Libre",         symbol: "gift.fill",           colorAsset: "AccentCoral",   sortOrder: 8),
        .init(code: "pamasko",       name: "Pamasko",       symbol: "snowflake",           colorAsset: "PrimaryPurple", sortOrder: 9),
        .init(code: "ipon",          name: "Ipon",          symbol: "banknote.fill",       colorAsset: "SuccessGreen",  sortOrder: 10),
        .init(code: "iba_pa",        name: "Iba pa",        symbol: "ellipsis.circle",     colorAsset: "PrimaryPurple", sortOrder: 99)
    ]

    static func seedIfNeeded(in context: NSManagedObjectContext) async {
        await context.perform {
            let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
            request.fetchLimit = 1
            if let existing = try? context.count(for: request), existing > 0 {
                return
            }

            let now = Date()
            for seed in seeds {
                let object = NSEntityDescription.insertNewObject(forEntityName: "Category", into: context)
                object.setValue(UUID(), forKey: "id")
                object.setValue(seed.code, forKey: "code")
                object.setValue(seed.name, forKey: "name")
                object.setValue(seed.symbol, forKey: "iconSystemName")
                object.setValue(seed.colorAsset, forKey: "colorAssetName")
                object.setValue(seed.sortOrder, forKey: "sortOrder")
                object.setValue(now, forKey: "createdAt")
            }

            do {
                try context.save()
            } catch {
                assertionFailure("Kuwenta: failed to seed categories - \(error)")
            }
        }
    }
}
