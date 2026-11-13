import CoreData
import XCTest
@testable import Watchlist

@MainActor
final class FavoriteStorageTests: XCTestCase {
    func test_allFavoriteStoresSupportIdempotentInsertAndDelete() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        let stores: [FavoriteStorage] = [
            FavoriteMovieStorage(viewContext: context),
            FavoriteArtistStorage(viewContext: context),
            FavoriteTVSerieStorage(viewContext: context)
        ]
        for store in stores {
            XCTAssertFalse(store.isFavorite(id: 42))
            store.addFavorite(id: 42, name: "Favorite")
            store.addFavorite(id: 42, name: "Favorite")
            XCTAssertTrue(store.isFavorite(id: 42))
            store.deleteFavorite(id: 42)
            XCTAssertFalse(store.isFavorite(id: 42))
            store.deleteFavorite(id: 42)
            store.addFavorite(id: Int.max, name: "Out of range")
            XCTAssertFalse(store.isFavorite(id: Int.max))
        }
    }

    func test_storesRemainIndependent() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.container.viewContext
        let movies = FavoriteMovieStorage(viewContext: context)
        let artists = FavoriteArtistStorage(viewContext: context)
        let series = FavoriteTVSerieStorage(viewContext: context)
        movies.addFavorite(id: 1, name: "Movie")
        XCTAssertEqual(movies.fetchMovies().count, 1)
        XCTAssertTrue(artists.fetchArtists().isEmpty)
        XCTAssertTrue(series.fetchSeries().isEmpty)
    }
}
