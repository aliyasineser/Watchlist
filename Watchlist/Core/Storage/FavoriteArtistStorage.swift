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

    let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    private init() {}

    func addFavorite(id: Int, name: String) {
        let movie = FavoriteArtist(context: viewContext)
        movie.id = Int32(id)
        movie.name = name
        saveContext()
        print("added")
    }

    func deleteFavorite(id: Int) {
        let request = FavoriteArtist.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let movies = try viewContext.fetch(request)

            if let movie = movies.first {
                viewContext.delete(movie)
                print("removed")
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
}