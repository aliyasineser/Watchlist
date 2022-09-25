//
//  FavoriteStorage.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.09.2022.
//

import Foundation
import CoreData

protocol FavoriteStorage {

    var viewContext: NSManagedObjectContext { get }

    func saveContext()
    func addFavorite(id: Int, name: String)
    func deleteFavorite(id: Int)
    func isFavorite(id: Int) -> Bool
}

extension FavoriteStorage {
    func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


final class FavoriteStorageStub: FavoriteStorage {
    var viewContext: NSManagedObjectContext = NSManagedObjectContext(.privateQueue)

    func addFavorite(id: Int, name: String) {}

    func deleteFavorite(id: Int) {}

    var isFavoriteStub: Bool = false
    func isFavorite(id: Int) -> Bool {
        return isFavoriteStub
    }


}
