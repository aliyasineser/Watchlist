import CoreData
import XCTest
@testable import Watchlist

@MainActor
final class FavoriteStorageTests: XCTestCase {
    func test_allFavoriteStoresSupportIdempotentInsertAndDelete() throws {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        let stores: [FavoriteStorage] = [
            FavoriteMovieStorage(viewContext: context),
            FavoriteArtistStorage(viewContext: context),
            FavoriteTVSerieStorage(viewContext: context)
        ]
        for store in stores {
            XCTAssertFalse(try store.isFavorite(id: 42))
            try store.addFavorite(id: 42, name: "Favorite")
            try store.addFavorite(id: 42, name: "Favorite")
            XCTAssertTrue(try store.isFavorite(id: 42))
            try store.deleteFavorite(id: 42)
            XCTAssertFalse(try store.isFavorite(id: 42))
            try store.deleteFavorite(id: 42)
            XCTAssertThrowsError(try store.addFavorite(id: Int.max, name: "Out of range"))
            XCTAssertFalse(try store.isFavorite(id: Int.max))
        }
    }

    func test_storesRemainIndependent() throws {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        let movies = FavoriteMovieStorage(viewContext: context)
        let artists = FavoriteArtistStorage(viewContext: context)
        let series = FavoriteTVSerieStorage(viewContext: context)
        try movies.addFavorite(id: 1, name: "Movie")
        XCTAssertEqual(try movies.fetchMovies().count, 1)
        XCTAssertTrue(try artists.fetchArtists().isEmpty)
        XCTAssertTrue(try series.fetchSeries().isEmpty)
    }

    func test_failedSaveRollsBackInsteadOfCrashing() throws {
        let persistence = PersistenceController(inMemory: true)
        let context = FailingSaveContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistence.container.persistentStoreCoordinator
        let store = FavoriteMovieStorage(viewContext: context)
        XCTAssertThrowsError(try store.addFavorite(id: 1, name: "Movie"))
        XCTAssertTrue(try store.fetchMovies().isEmpty)
        XCTAssertFalse(context.hasChanges)
    }
}

private final class FailingSaveContext: NSManagedObjectContext {
    override func save() throws { throw CocoaError(.fileWriteOutOfSpace) }
}
