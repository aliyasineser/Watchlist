//
//  Persistence.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 23.03.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: false)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            let movie = FavoriteMovie(context: viewContext)
            movie.id = 5
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    func saveContext() {
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func addFavoriteMovie(id: Int, name: String) {
        let movie = FavoriteMovie(context: PersistenceController.shared.container.viewContext)
        movie.id = Int32(id)
        movie.name = name
        saveContext()
        print("added")
    }

    func deleteFavoriteMovie(id: Int) {
        let viewContext = PersistenceController.shared.container.viewContext
        let request = FavoriteMovie.fetchRequest()
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

    func isFavoriteMovie(id: Int) -> Bool {
        let viewContext = PersistenceController.shared.container.viewContext
        let request = FavoriteMovie.fetchRequest()
        request.fetchLimit =  1
        request.predicate = NSPredicate(format: "id == %d", id)

        do {
            let count = try viewContext.count(for: request)
            return count > 0
        } catch {
            fatalError("Failed to check if favorite movie present: \(error)")
        }
    }

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Watchlist")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application,
                // although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions
                 * or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
