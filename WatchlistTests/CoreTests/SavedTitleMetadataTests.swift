import XCTest
@testable import Watchlist

@MainActor
final class SavedTitleMetadataTests: XCTestCase {
    private let movie = SavedTitle(tmdbID: 1, mediaType: .movie, title: "Migrated movie")

    func testMetadataRequestUsesTypedEndpointWithoutCreditsPayload() {
        let movieRequest = SavedTitleMetadataRequest(title: movie)
        XCTAssertEqual(movieRequest.path, "/movie/1")
        XCTAssertNil(movieRequest.urlParams["append_to_response"])
        let series = SavedTitle(tmdbID: 1, mediaType: .tv, title: "Series")
        XCTAssertEqual(SavedTitleMetadataRequest(title: series).path, "/tv/1")
    }

    func testFetchPersistsPosterWithoutChangingUserProgressAndDoesNotRepeat() async {
        let service = MetadataServiceMock()
        let repository = MetadataRepositoryMock()
        let loader = SavedTitleMetadataLoaderImpl(service: service)
        let store = WatchLibraryStoreImpl(repository: repository, artwork: MetadataArtwork(), metadataLoader: loader)
        await store.load()
        await store.setStatus(.watched, for: movie)
        await store.setRating(8, for: movie)
        let originalDate = store.entry(for: movie)?.addedAt
        await store.hydrateMetadata(for: movie.id)
        XCTAssertEqual(store.entry(for: movie)?.title.posterURL, "https://image.tmdb.org/poster.jpg")
        XCTAssertEqual(store.entry(for: movie)?.status, .watched)
        XCTAssertEqual(store.entry(for: movie)?.personalRating, 8)
        XCTAssertEqual(store.entry(for: movie)?.addedAt, originalDate)
        await store.hydrateMetadata(for: movie.id)
        XCTAssertEqual(service.requests, 1)
        let reloaded = WatchLibraryStoreImpl(repository: repository, artwork: MetadataArtwork(), metadataLoader: loader)
        await reloaded.load()
        await reloaded.hydrateMetadata(for: movie.id)
        XCTAssertEqual(service.requests, 1)
        // A detail view opened before hydration must not replace the new poster with its old snapshot.
        await store.setStatus(.watching, for: movie)
        XCTAssertNotNil(store.entry(for: movie)?.title.posterURL)
    }

    func testFailureBackoffAndMissingPosterAreNotRepeatedOnEveryAppearance() async {
        let service = MetadataServiceMock()
        var now = Date(timeIntervalSince1970: 100_000)
        let loader = SavedTitleMetadataLoaderImpl(service: service, now: { now })
        service.shouldFail = true
        _ = await loader.fetchIfNeeded(movie)
        _ = await loader.fetchIfNeeded(movie)
        XCTAssertEqual(service.requests, 1)
        loader.resetFailures()
        service.shouldFail = false
        service.hasPoster = false
        let result = await loader.fetchIfNeeded(movie)
        XCTAssertNotNil(result?.metadataFetchedAt)
        if let result { _ = await loader.fetchIfNeeded(result) }
        XCTAssertEqual(service.requests, 2)
        now.addTimeInterval(86_401)
        if let result { _ = await loader.fetchIfNeeded(result) }
        XCTAssertEqual(service.requests, 3)
    }

    func testConcurrentRequestsAreBoundedDeduplicatedAndDeletedTitleStaysDeleted() async {
        let service = SuspendedMetadataService()
        let loader = SavedTitleMetadataLoaderImpl(service: service)
        let requested = expectation(description: "Only two requests start")
        requested.expectedFulfillmentCount = 2
        service.onRequest = { requested.fulfill() }
        let first = Task { await loader.fetchIfNeeded(self.movie) }
        let secondTitle = SavedTitle(tmdbID: 2, mediaType: .tv, title: "Series")
        let second = Task { await loader.fetchIfNeeded(secondTitle) }
        await fulfillment(of: [requested], timeout: 2)
        let duplicate = await loader.fetchIfNeeded(movie)
        XCTAssertNil(duplicate)
        let thirdStarted = expectation(description: "Third starts after a slot is released")
        service.onRequest = { thirdStarted.fulfill() }
        let third = Task { await loader.fetchIfNeeded(SavedTitle(tmdbID: 3, mediaType: .movie, title: "Third")) }
        await Task.yield()
        XCTAssertEqual(service.requests, 2)
        service.completeAll()
        await fulfillment(of: [thirdStarted], timeout: 2)
        service.completeAll()
        _ = await first.value
        _ = await second.value
        _ = await third.value

        let repository = MetadataRepositoryMock()
        let store = WatchLibraryStoreImpl(repository: repository, artwork: MetadataArtwork(), metadataLoader: loader)
        await store.load()
        await store.setStatus(.watching, for: movie)
        let started = expectation(description: "Hydration begins")
        service.onRequest = { started.fulfill() }
        let hydration = Task { await store.hydrateMetadata(for: self.movie.id) }
        await fulfillment(of: [started], timeout: 2)
        await store.remove(movie)
        service.completeAll()
        await hydration.value
        XCTAssertNil(store.entry(for: movie))
    }

    func testSimultaneousMetadataResultsAreBothSaved() async {
        let service = SuspendedMetadataService()
        let store = WatchLibraryStoreImpl(
            repository: MetadataRepositoryMock(), artwork: MetadataArtwork(),
            metadataLoader: SavedTitleMetadataLoaderImpl(service: service)
        )
        await store.load()
        let secondTitle = SavedTitle(tmdbID: 2, mediaType: .tv, title: "Series")
        await store.setStatus(.watching, for: movie)
        await store.setStatus(.watched, for: secondTitle)
        let started = expectation(description: "Both requests start")
        started.expectedFulfillmentCount = 2
        service.onRequest = { started.fulfill() }
        let first = Task { await store.hydrateMetadata(for: self.movie.id) }
        let second = Task { await store.hydrateMetadata(for: secondTitle.id) }
        await fulfillment(of: [started], timeout: 2)
        service.completeAll()
        await first.value
        await second.value
        XCTAssertNotNil(store.entry(for: movie)?.title.posterURL)
        XCTAssertNotNil(store.entry(for: secondTitle)?.title.posterURL)
        XCTAssertEqual(store.entry(for: secondTitle)?.status, .watched)
    }

    func testMetadataFailurePreservesLibraryAndDoesNotRaiseAnAlert() async {
        let service = MetadataServiceMock()
        service.shouldFail = true
        let store = WatchLibraryStoreImpl(
            repository: MetadataRepositoryMock(), artwork: MetadataArtwork(),
            metadataLoader: SavedTitleMetadataLoaderImpl(service: service)
        )
        await store.load()
        await store.setStatus(.watching, for: movie)
        await store.hydrateMetadata(for: movie.id)
        XCTAssertEqual(store.entry(for: movie)?.title, movie)
        XCTAssertNil(store.error)
    }
}

@MainActor
private final class MetadataServiceMock: SavedTitleMetadataService {
    var requests = 0
    var shouldFail = false
    var hasPoster = true
    func fetch(_ title: SavedTitle) async throws -> SavedTitle {
        requests += 1
        if shouldFail { throw URLError(.notConnectedToInternet) }
        var result = title
        result.posterURL = hasPoster ? "https://image.tmdb.org/poster.jpg" : nil
        return result
    }
}

@MainActor
private final class SuspendedMetadataService: SavedTitleMetadataService {
    var requests = 0
    var onRequest: (() -> Void)?
    private var pending: [(SavedTitle, CheckedContinuation<SavedTitle, Error>)] = []
    func fetch(_ title: SavedTitle) async throws -> SavedTitle {
        requests += 1
        return try await withCheckedThrowingContinuation {
            pending.append((title, $0))
            onRequest?()
        }
    }
    func completeAll() {
        let requests = pending
        pending.removeAll()
        for (title, continuation) in requests {
            var enriched = title
            enriched.posterURL = "https://image.tmdb.org/poster.jpg"
            continuation.resume(returning: enriched)
        }
    }
}

private actor MetadataRepositoryMock: WatchLibraryRepository {
    private var document = WatchLibraryDocument(importedFavorites: true)
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct MetadataArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
