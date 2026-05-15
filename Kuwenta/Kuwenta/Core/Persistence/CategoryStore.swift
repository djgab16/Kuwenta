import CoreData
import Foundation
import SwiftUI

struct CategoryRecord: Identifiable, Hashable {
    let id: UUID
    var code: String
    var name: String
    var iconSystemName: String
    var colorAssetName: String
    var sortOrder: Int16
}

protocol CategoryStore {
    func allCategories() throws -> [CategoryRecord]
}

final class CoreDataCategoryStore: CategoryStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func allCategories() throws -> [CategoryRecord] {
        let request = NSFetchRequest<NSManagedObject>(entityName: "Category")
        request.sortDescriptors = [
            NSSortDescriptor(key: "sortOrder", ascending: true),
            NSSortDescriptor(key: "name", ascending: true)
        ]
        return try context.fetch(request).compactMap { object in
            guard
                let id = object.value(forKey: "id") as? UUID,
                let code = object.value(forKey: "code") as? String,
                let name = object.value(forKey: "name") as? String
            else {
                return nil
            }
            return CategoryRecord(
                id: id,
                code: code,
                name: name,
                iconSystemName: (object.value(forKey: "iconSystemName") as? String) ?? "circle",
                colorAssetName: (object.value(forKey: "colorAssetName") as? String) ?? "PrimaryPurple",
                sortOrder: (object.value(forKey: "sortOrder") as? Int16) ?? 0
            )
        }
    }
}

private struct CategoryStoreKey: EnvironmentKey {
    static let defaultValue: CategoryStore = CoreDataCategoryStore(
        context: PersistentCloudKitController.shared.viewContext
    )
}

extension EnvironmentValues {
    var categoryStore: CategoryStore {
        get { self[CategoryStoreKey.self] }
        set { self[CategoryStoreKey.self] = newValue }
    }
}
