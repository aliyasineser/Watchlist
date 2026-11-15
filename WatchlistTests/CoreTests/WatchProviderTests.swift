import XCTest
@testable import Watchlist

@MainActor
final class WatchProviderTests: XCTestCase {
    func testCountryResponseSubscriptionMatchingAndSafeLinks() throws {
        let json = Data("""
        {"results":{"DE":{"link":"https://www.themoviedb.org/movie/1/watch?locale=DE",
        "flatrate":[{"provider_id":8,"provider_name":"Example","logo_path":null}],
        "rent":[{"provider_id":9,"provider_name":"Rental"}]}}}
        """.utf8)
        let response = try JSONDecoder().decode(ProviderResponse.self, from: json)
        let availability = WatchAvailability(response: response, fetchedAt: .now, isStale: false)
        XCTAssertTrue(availability.included(in: [8], region: "DE"))
        XCTAssertFalse(availability.included(in: [9], region: "DE"))
        XCTAssertFalse(availability.included(in: [8], region: "GB"))
        XCTAssertNotNil(availability.region("DE")?.destination)
        let unsafe = ProviderRegion(link: "https://example.com", flatrate: nil,
                                    free: nil, ads: nil, rent: nil, buy: nil)
        XCTAssertNil(unsafe.destination)
        let movie = SavedTitle(tmdbID: 1, mediaType: .movie, title: "Movie")
        XCTAssertEqual(WatchProviderRequest(title: movie).path, "/movie/1/watch/providers")
        let series = SavedTitle(tmdbID: 1, mediaType: .tv, title: "Series")
        XCTAssertEqual(WatchProviderRequest(title: series).path, "/tv/1/watch/providers")
    }

    func testCacheReturnsOfflineStaleDataAndLibraryChecksOnlyOneBatch() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let cache = ProviderCacheImpl(url: directory.appendingPathComponent("cache.json"))
        let response = ProviderResponse(results: ["DE": providerRegion()])
        try await cache.save(ProviderCacheEntry(response: response, fetchedAt: .distantPast), id: "movie-1")
        let service = WatchProviderServiceImpl(
            manager: DefaultRequestManager(apiManager: OfflineProviderAPI()), cache: cache
        )
        let title = SavedTitle(tmdbID: 1, mediaType: .movie, title: "Movie")
        let offline = try await service.availability(for: title, force: false)
        XCTAssertTrue(offline.isStale)
        XCTAssertTrue(offline.included(in: [8], region: "DE"))

        let preferences = preferences()
        preferences.region = "DE"
        preferences.subscriptions = [8]
        let store = WatchLibraryStoreImpl(repository: ProviderLibraryRepository(), artwork: ProviderArtwork())
        await store.load()
        let mock = ProviderServiceMock(response: response)
        let presenter = ProviderLibraryPresenterImpl(store: store, preferences: preferences, service: mock)
        await presenter.reset()
        XCTAssertEqual(mock.requests, 20)
        XCTAssertEqual(presenter.entries.count, 20)
        XCTAssertTrue(presenter.hasMore)
        await presenter.loadMore()
        XCTAssertEqual(presenter.checked, 21)
        XCTAssertFalse(presenter.hasMore)
        preferences.region = "GB"
        await presenter.reset()
        XCTAssertTrue(presenter.entries.isEmpty)
    }

    private func providerRegion() -> ProviderRegion {
        ProviderRegion(link: nil, flatrate: [WatchProvider(id: 8, name: "Example", logoPath: nil)],
                       free: nil, ads: nil, rent: nil, buy: nil)
    }
    private func preferences() -> ProviderPreferencesImpl {
        let defaults = UserDefaults(suiteName: "ProviderTests") ?? .standard
        defaults.removePersistentDomain(forName: "ProviderTests")
        return ProviderPreferencesImpl(defaults: defaults)
    }
}

private struct OfflineProviderAPI: APIManager {
    func initRequest(with request: NetworkRequest) async throws -> Data { throw URLError(.notConnectedToInternet) }
}

@MainActor
private final class ProviderServiceMock: WatchProviderService {
    let response: ProviderResponse
    var requests = 0
    init(response: ProviderResponse) { self.response = response }
    func availability(for title: SavedTitle, force: Bool) async throws -> WatchAvailability {
        requests += 1
        return WatchAvailability(response: response, fetchedAt: .now, isStale: false)
    }
}

private actor ProviderLibraryRepository: WatchLibraryRepository {
    func load() async throws -> WatchLibraryDocument {
        WatchLibraryDocument(importedFavorites: true, entries: (1...21).map {
            WatchEntry(title: SavedTitle(tmdbID: $0, mediaType: .movie, title: "Movie \($0)"), status: .wantToWatch,
                       addedAt: Date(timeIntervalSince1970: Double($0)), updatedAt: .now)
        })
    }
    func save(_ document: WatchLibraryDocument) async throws { }
}

private struct ProviderArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
