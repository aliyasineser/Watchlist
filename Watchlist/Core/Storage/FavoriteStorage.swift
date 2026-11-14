//
//  FavoriteStorage.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.09.2022.
//

import Foundation
import CoreData

@MainActor
protocol FavoriteStorage {

    var viewContext: NSManagedObjectContext { get }

    func saveContext() throws
    func addFavorite(id: Int, name: String) throws
    func deleteFavorite(id: Int) throws
    func isFavorite(id: Int) throws -> Bool
}

extension FavoriteStorage {
    func saveContext() throws {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            throw error
        }
    }
}

final class FavoriteStorageStub: FavoriteStorage {
    var viewContext: NSManagedObjectContext = NSManagedObjectContext(.privateQueue)

    func addFavorite(id: Int, name: String) throws {}

    func deleteFavorite(id: Int) throws {}

    var isFavoriteStub: Bool = false
    func isFavorite(id: Int) throws -> Bool {
        return isFavoriteStub
    }

}

enum FavoriteStorageError: LocalizedError {
    case invalidIdentifier

    var errorDescription: String? { "This title has an invalid identifier and could not be saved." }
}
