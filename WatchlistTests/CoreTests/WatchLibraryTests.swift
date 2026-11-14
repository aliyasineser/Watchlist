import XCTest
@testable import Watchlist

@MainActor
final class WatchLibraryTests: XCTestCase {
    private let movie = SavedTitle(tmdbID: 1, mediaType: .movie, title: "Zebra")
    private let series = SavedTitle(tmdbID: 1, mediaType: .tv, title: "Alpha")

    func testStatusesRatingsAndTypedIdentity() async {
        let store = makeStore()
        await store.load()
        await store.setStatus(.wantToWatch, for: movie)
        await store.setStatus(.watching, for: series)
        await store.setStatus(.watched, for: movie)
        await store.setRating(9, for: movie)
        XCTAssertEqual(store.entries.count, 2)
        XCTAssertEqual(store.entry(for: movie)?.status, .watched)
        XCTAssertEqual(store.entry(for: movie)?.personalRating, 9)
        XCTAssertEqual(store.filtered(status: .watching, type: .tv, sort: .title).map(\.id), [series.id])
        XCTAssertEqual(store.filtered(status: nil, type: nil, sort: .title).map(\.id), [series.id, movie.id])
        XCTAssertEqual(store.filtered(status: nil, type: nil, sort: .rating).first?.id, movie.id)
        await store.setRating(11, for: movie)
        XCTAssertNotNil(store.error)
        XCTAssertEqual(store.entry(for: movie)?.personalRating, 9)
        await store.setRating(nil, for: movie)
        XCTAssertNil(store.entry(for: movie)?.personalRating)
        await store.remove(movie)
        XCTAssertEqual(store.entries.map(\.id), [series.id])
    }

    func testFailedSaveDoesNotPublishOrRemoveExistingEntry() async {
        let repository = LibraryRepositoryMock()
        let store = makeStore(repository: repository)
        await store.load()
        await store.setStatus(.watching, for: movie)
        await repository.failSaves()
        await store.setStatus(.watched, for: movie)
        XCTAssertEqual(store.entry(for: movie)?.status, .watching)
        XCTAssertNotNil(store.error)
        await store.remove(movie)
        XCTAssertNotNil(store.entry(for: movie))
    }

    func testMigrationIsIdempotentAndDeletedFavoritesStayDeleted() async {
        let repository = LibraryRepositoryMock()
        let first = WatchLibraryStoreImpl(repository: repository, artwork: LibraryArtworkMock()) {
            [self.movie, self.movie, self.series]
        }
        await first.load()
        XCTAssertEqual(first.entries.count, 2)
        await first.remove(movie)
        let second = WatchLibraryStoreImpl(repository: repository, artwork: LibraryArtworkMock()) { [self.movie] }
        await second.load()
        XCTAssertEqual(second.entries.map(\.id), [series.id])
    }

    func testMetadataRefreshPreservesUserChoicesAndDates() async {
        let store = makeStore()
        await store.load()
        await store.setStatus(.watched, for: movie)
        await store.setRating(8, for: movie)
        let original = store.entry(for: movie)
        var enriched = movie
        enriched.overview = "Saved for offline reading"
        await store.refreshMetadata(enriched)
        let refreshed = store.entry(for: movie)
        XCTAssertEqual(refreshed?.title.overview, enriched.overview)
        XCTAssertEqual(refreshed?.personalRating, 8)
        XCTAssertEqual(refreshed?.status, .watched)
        XCTAssertEqual(refreshed?.addedAt, original?.addedAt)
        XCTAssertEqual(refreshed?.updatedAt, original?.updatedAt)
    }

    func testDiskRoundTripAndCorruptionProtection() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let file = directory.appendingPathComponent("library.json")
        let repository = WatchLibraryRepositoryImpl(fileURL: file)
        let store = makeStore(repository: repository)
        await store.load()
        await store.setStatus(.watched, for: movie)
        await store.setRating(10, for: movie)
        let reloaded = makeStore(repository: repository)
        await reloaded.load()
        XCTAssertEqual(reloaded.entries, store.entries)

        let corrupt = Data("broken json".utf8)
        try corrupt.write(to: file)
        let failed = makeStore(repository: repository)
        await failed.load()
        XCTAssertFalse(failed.isLoaded)
        XCTAssertNotNil(failed.error)
        await failed.setStatus(.watching, for: series)
        XCTAssertTrue(failed.entries.isEmpty)
        XCTAssertEqual(try Data(contentsOf: file), corrupt)
    }

    func testUnsupportedVersionIsPreserved() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let file = directory.appendingPathComponent("library.json")
        let repository = WatchLibraryRepositoryImpl(fileURL: file)
        var future = WatchLibraryDocument()
        future.version = 99
        try await repository.save(future)
        let before = try Data(contentsOf: file)
        let store = makeStore(repository: repository)
        await store.load()
        XCTAssertFalse(store.isLoaded)
        XCTAssertNotNil(store.error)
        XCTAssertEqual(try Data(contentsOf: file), before)
    }

    func testFailedMigrationCanRetryWithoutLosingFavorites() async {
        let repository = LibraryRepositoryMock()
        await repository.failSaves()
        let store = WatchLibraryStoreImpl(repository: repository, artwork: LibraryArtworkMock()) { [self.movie] }
        await store.load()
        XCTAssertFalse(store.isLoaded)
        XCTAssertTrue(store.entries.isEmpty)
        await repository.allowSaves()
        await store.load()
        XCTAssertTrue(store.isLoaded)
        XCTAssertEqual(store.entries.map(\.id), [movie.id])
    }

    func testArtworkLocalLookupAndRemoval() async throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let cache = ArtworkCacheImpl(directory: directory)
        XCTAssertNil(cache.localURL(for: movie.id))
        let file = directory.appendingPathComponent(movie.id + ".image")
        try Data([1, 2, 3]).write(to: file)
        XCTAssertEqual(cache.localURL(for: movie.id), file)
        await cache.remove(id: movie.id)
        XCTAssertNil(cache.localURL(for: movie.id))
    }

    private func makeStore(repository: WatchLibraryRepository = LibraryRepositoryMock()) -> WatchLibraryStoreImpl {
        WatchLibraryStoreImpl(repository: repository, artwork: LibraryArtworkMock())
    }
}

private actor LibraryRepositoryMock: WatchLibraryRepository {
    private var document = WatchLibraryDocument()
    private var fail = false
    func load() async throws -> WatchLibraryDocument { document }
    func failSaves() { fail = true }
    func allowSaves() { fail = false }
    func save(_ document: WatchLibraryDocument) async throws {
        if fail { throw CocoaError(.fileWriteNoPermission) }
        self.document = document
    }
}

private struct LibraryArtworkMock: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
