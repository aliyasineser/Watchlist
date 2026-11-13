//
//  FavoriteTVSerieStorage.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.09.2022.
//

import Foundation
import CoreData

class FavoriteTVSerieStorage: FavoriteStorage {

    public static let shared: FavoriteTVSerieStorage = FavoriteTVSerieStorage()

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func addFavorite(id: Int, name: String) {
        guard let storedID = Int32(exactly: id), !isFavorite(id: id) else { return }
        let movie = FavoriteSerie(context: viewContext)
        movie.id = storedID
        movie.name = name
        saveContext()
    }

    func deleteFavorite(id: Int) {
        let request = FavoriteSerie.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let series = try viewContext.fetch(request)

            if let serie = series.first {
                viewContext.delete(serie)
            }
        } catch {
            fatalError("Failed to delete serie movie: \(error)")
        }
        saveContext()
    }

    func isFavorite(id: Int) -> Bool {
        let request = FavoriteSerie.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            fatalError("Failed to check if favorite serie present: \(error)")
        }
    }

    func fetchSeries() -> [FavoriteSerie] {
        let request = FavoriteSerie.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Failed to delete favorite movies: \(error)")

        }
    }
}
