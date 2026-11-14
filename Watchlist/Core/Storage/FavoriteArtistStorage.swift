import CoreData

@MainActor
final class FavoriteArtistStorage: FavoriteStorage {
    static let shared = FavoriteArtistStorage()
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext? = nil) {
        self.viewContext = viewContext ?? PersistenceController.shared.container.viewContext
    }

    func addFavorite(id: Int, name: String) throws {
        guard let storedID = Int32(exactly: id) else { throw FavoriteStorageError.invalidIdentifier }
        guard try !isFavorite(id: id) else { return }
        let record = FavoriteArtist(context: viewContext)
        record.id = storedID
        record.name = name
        try saveContext()
    }

    func deleteFavorite(id: Int) throws {
        let request = FavoriteArtist.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        for record in try viewContext.fetch(request) { viewContext.delete(record) }
        try saveContext()
    }

    func isFavorite(id: Int) throws -> Bool {
        let request = FavoriteArtist.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        return try viewContext.count(for: request) > 0
    }

    func fetchArtists() throws -> [FavoriteArtist] {
        try viewContext.fetch(FavoriteArtist.fetchRequest())
    }
}
