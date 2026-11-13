//
//  FavoriteArtistStorage.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.09.2022.
//

import Foundation
import CoreData

class FavoriteArtistStorage: FavoriteStorage {

    public static let shared: FavoriteArtistStorage = FavoriteArtistStorage()

    let viewContext: NSManagedObjectContext

    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = viewContext
    }

    func addFavorite(id: Int, name: String) {
        guard let storedID = Int32(exactly: id), !isFavorite(id: id) else { return }
        let movie = FavoriteArtist(context: viewContext)
        movie.id = storedID
        movie.name = name
        saveContext()
    }

    func deleteFavorite(id: Int) {
        let request = FavoriteArtist.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let movies = try viewContext.fetch(request)

            if let movie = movies.first {
                viewContext.delete(movie)
            }
        } catch {
            fatalError("Failed to delete favorite movie: \(error)")
        }
        saveContext()
    }

    func isFavorite(id: Int) -> Bool {
        let request = FavoriteArtist.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            fatalError("Failed to check if favorite movie present: \(error)")
        }
    }

    func fetchArtists() -> [FavoriteArtist] {
        let request = FavoriteArtist.fetchRequest()
        do {
            return try viewContext.fetch(request)
        } catch {
            fatalError("Failed to fetch favorite artists: \(error)")
        }
    }
}
