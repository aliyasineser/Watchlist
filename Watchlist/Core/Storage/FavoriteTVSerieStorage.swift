import CoreData

@MainActor
final class FavoriteTVSerieStorage: FavoriteStorage {
    static let shared = FavoriteTVSerieStorage()
    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext? = nil) {
        self.viewContext = viewContext ?? PersistenceController.shared.container.viewContext
    }

    func addFavorite(id: Int, name: String) throws {
        guard let storedID = Int32(exactly: id) else { throw FavoriteStorageError.invalidIdentifier }
        guard try !isFavorite(id: id) else { return }
        let record = FavoriteSerie(context: viewContext)
        record.id = storedID
        record.name = name
        try saveContext()
    }

    func deleteFavorite(id: Int) throws {
        let request = FavoriteSerie.fetchRequest()
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        for record in try viewContext.fetch(request) { viewContext.delete(record) }
        try saveContext()
    }

    func isFavorite(id: Int) throws -> Bool {
        let request = FavoriteSerie.fetchRequest()
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %lld", Int64(id))
        return try viewContext.count(for: request) > 0
    }

    func fetchSeries() throws -> [FavoriteSerie] {
        try viewContext.fetch(FavoriteSerie.fetchRequest())
    }
}
