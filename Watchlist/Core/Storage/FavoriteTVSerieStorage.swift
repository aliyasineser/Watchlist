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

    let viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext

    private init() {}

    func addFavorite(id: Int, name: String) {
        let movie = FavoriteSerie(context: viewContext)
        movie.id = Int32(id)
        movie.name = name
        saveContext()
        print("added")
    }

    func deleteFavorite(id: Int) {
        let request = FavoriteSerie.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)
        do {
            let series = try viewContext.fetch(request)

            if let serie = series.first {
                viewContext.delete(serie)
                print("removed")
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
}

