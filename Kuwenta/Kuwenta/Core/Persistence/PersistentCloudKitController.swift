import CoreData
import CloudKit
import Foundation

/// Owns the Core Data + CloudKit stack for the Kuwenta app target.
///
/// In Phase 1 the store is private to the app sandbox. From Phase 2 onward
/// the Message Filter Extension will read/write through the same model via
/// the `KuwentaCore` package, switching to an App Group container URL.
final class PersistentCloudKitController {
    static let shared = PersistentCloudKitController()

    /// Toggle when wiring CloudKit in your developer account.
    /// Keep `false` until iCloud + CloudKit capability is added to the target.
    static let cloudKitEnabled = false

    /// Set to your real CloudKit container ID once configured in capabilities.
    /// Example: `iCloud.ph.kuwenta.app`.
    static let cloudKitContainerID = "iCloud.ph.kuwenta.app"

    let container: NSPersistentCloudKitContainer

    private init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Kuwenta")

        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Kuwenta: missing persistent store description")
        }

        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }

        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        if Self.cloudKitEnabled {
            description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
                containerIdentifier: Self.cloudKitContainerID
            )
        } else {
            description.cloudKitContainerOptions = nil
        }

        container.loadPersistentStores { _, error in
            if let error {
                assertionFailure("Kuwenta: failed to load store - \(error)")
            }
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }

    var viewContext: NSManagedObjectContext { container.viewContext }

    func newBackgroundContext() -> NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }

    /// First-launch seeding of Filipino-default categories. Idempotent.
    func bootstrapIfNeeded() async {
        await CategorySeeder.seedIfNeeded(in: newBackgroundContext())
    }

    // MARK: Test helpers

    static func inMemoryForTesting() -> PersistentCloudKitController {
        PersistentCloudKitController(inMemory: true)
    }
}
