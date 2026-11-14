import CoreData
import Observation

@MainActor
@Observable
final class PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    private(set) var loadError: Error?

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Watchlist")
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }
        loadStores()
    }

    /// Retry the existing store. Never delete user data or silently replace it with an empty store.
    func loadStores() {
        guard container.persistentStoreCoordinator.persistentStores.isEmpty else { return }
        loadError = nil
        for description in container.persistentStoreDescriptions {
            description.shouldAddStoreAsynchronously = false
        }
        var failure: Error?
        container.loadPersistentStores { _, error in failure = error }
        loadError = failure
    }
}
