import XCTest
@testable import Watchlist

@MainActor
final class EpisodeProgressTests: XCTestCase {
    private let title = SavedTitle(tmdbID: 1, mediaType: .tv, title: "A series")
    private let today = Date(timeIntervalSince1970: 1_700_000_000)

    func testNextEpisodeExcludesWatchedSpecialsFutureAndUnknownDates() {
        let first = episode(1)
        let second = episode(2)
        let future = episode(3, airDate: "2999-01-01")
        let unknown = episode(4, airDate: nil)
        let special = EpisodeRecord(seasonNumber: 0, episodeNumber: 1, name: "Special", airDate: "2020-01-01")
        let progress = SeriesProgress(seasons: [EpisodeSeason(seasonNumber: 1, name: "One",
                                                            episodes: [future, unknown, second, special, first])],
                                      watchedIDs: [first.id])
        XCTAssertEqual(progress.nextEpisode(on: today)?.id, second.id)
        XCTAssertFalse(episode(5, airDate: "invalid").hasAired(on: today))
        XCTAssertFalse(episode(5, airDate: "2023-02-31").hasAired(on: today))
    }

    func testBulkMarkPreservesUnairedAndUndoRestoresPreviousProgress() async {
        let store = await makeStore()
        let season = EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1), episode(2),
                                  episode(3, airDate: "2999-01-01"), episode(4, airDate: nil)])
        _ = await store.cacheSeason(season, for: title)
        _ = await store.changeEpisodes(for: title, ids: ["1-1"], watched: true, now: today)
        let presenter = EpisodePresenterImpl(title: title, store: store, service: EpisodeServiceMock())
        await presenter.setWatched(ids: Set(season.episodes.map(\.id)), watched: true)
        XCTAssertEqual(presenter.progress.watchedIDs, ["1-1", "1-2"])
        XCTAssertTrue(presenter.canUndo)
        await presenter.undo()
        XCTAssertEqual(presenter.progress.watchedIDs, ["1-1"])
        XCTAssertFalse(presenter.canUndo)
    }

    func testRefreshKeepsWatchedFlagsAndOtherLibraryFields() async {
        let store = await makeStore()
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]), for: title)
        await store.setRating(9, for: title)
        _ = await store.changeEpisodes(for: title, ids: ["1-1"], watched: true, now: today)
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "Updated", episodes: [episode(1), episode(2)]),
                                    for: title)
        XCTAssertEqual(store.entry(for: title)?.episodeProgress?.watchedIDs, ["1-1"])
        XCTAssertEqual(store.entry(for: title)?.personalRating, 9)
        XCTAssertEqual(store.entry(for: title)?.status, .watching)
    }

    func testStaleUndoDoesNotOverwriteNewerProgress() async {
        let store = await makeStore()
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1), episode(2)]),
                                    for: title)
        _ = await store.changeEpisodes(for: title, ids: ["1-1", "1-2"], watched: true, now: today)
        let restored = await store.restoreEpisodes(for: title, before: [], expected: ["1-1"])
        XCTAssertFalse(restored)
        XCTAssertEqual(store.entry(for: title)?.episodeProgress?.watchedIDs, ["1-1", "1-2"])
    }

    func testFailedSaveDoesNotPublishProgress() async {
        let repository = EpisodeRepositoryMock()
        let store = await makeStore(repository: repository)
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]), for: title)
        await repository.failSaves()
        let changed = await store.changeEpisodes(for: title, ids: ["1-1"], watched: true, now: today)
        XCTAssertFalse(changed)
        XCTAssertEqual(store.entry(for: title)?.episodeProgress?.watchedIDs, [])
    }

    func testCachedCatalogAndSeasonWorkWithoutRequestsAndRefreshCanRetry() async {
        let store = await makeStore()
        _ = await store.cacheSeasonCatalog([EpisodeSeasonSummary(seasonNumber: 1, name: "One")], for: title)
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]), for: title)
        let service = EpisodeServiceMock()
        let presenter = EpisodePresenterImpl(title: title, store: store, service: service)
        await presenter.loadCatalog()
        await presenter.loadSeason()
        XCTAssertEqual(service.requests, 0)
        service.shouldFail = true
        await presenter.loadSeason(force: true)
        XCTAssertNotNil(presenter.error)
        XCTAssertEqual(presenter.season?.episodes.count, 1)
        service.shouldFail = false
        await presenter.loadSeason(force: true)
        XCTAssertNil(presenter.error)
        XCTAssertEqual(service.requests, 2)
    }

    func testLegacyEntryDecodesAndProgressSurvivesDiskRoundTrip() async throws {
        let data = Data(#"{"title":{"tmdbID":1,"mediaType":"tv","title":"Show"},"status":"watching","addedAt":0,"updatedAt":0}"#.utf8)
        XCTAssertNil(try JSONDecoder().decode(WatchEntry.self, from: data).episodeProgress)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: directory) }
        let repository = WatchLibraryRepositoryImpl(fileURL: directory.appendingPathComponent("library.json"))
        let store = await makeStore(repository: repository)
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]), for: title)
        _ = await store.changeEpisodes(for: title, ids: ["1-1"], watched: true, now: today)
        let reloaded = WatchLibraryStoreImpl(repository: repository, artwork: EpisodeArtworkMock())
        await reloaded.load()
        XCTAssertEqual(reloaded.entry(for: title)?.episodeProgress, store.entry(for: title)?.episodeProgress)
    }

    func testRequestRoutesAndSeasonDecoding() throws {
        XCTAssertEqual(EpisodeRequest(seriesID: 42).path, "/tv/42")
        XCTAssertEqual(EpisodeRequest(seriesID: 42, seasonNumber: 0).path, "/tv/42/season/0")
        let json = Data(#"{"season_number":1,"name":"One","episodes":[{"season_number":1,"episode_number":2,"name":"Episode","air_date":null}]}"#.utf8)
        let season = try JSONDecoder().decode(EpisodeSeason.self, from: json)
        XCTAssertEqual(season.episodes.first?.id, "1-2")
        XCTAssertNil(season.episodes.first?.airDate)
    }

    func testCatalogFailureSurvivesCachedSeasonAndCanBeRetried() async {
        let store = await makeStore()
        _ = await store.cacheSeasonCatalog([EpisodeSeasonSummary(seasonNumber: 1, name: "One")], for: title)
        _ = await store.cacheSeason(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]), for: title)
        let service = EpisodeServiceMock()
        let presenter = EpisodePresenterImpl(title: title, store: store, service: service)
        await presenter.loadCatalog()
        service.shouldFail = true
        await presenter.refresh()
        XCTAssertNotNil(presenter.catalogError)
        await presenter.loadSeason()
        XCTAssertNotNil(presenter.error)
        XCTAssertEqual(presenter.season?.episodes.count, 1)
        service.shouldFail = false
        await presenter.retry()
        XCTAssertNil(presenter.error)
    }

    func testLateSeasonResponseCannotReplaceChangedSelection() async {
        let store = await makeStore()
        let service = ControlledEpisodeService()
        let presenter = EpisodePresenterImpl(title: title, store: store, service: service)
        presenter.selectedSeason = 1
        let requested = expectation(description: "Season requested")
        service.onRequest = { requested.fulfill() }
        let request = Task { await presenter.loadSeason() }
        await fulfillment(of: [requested], timeout: 2)
        presenter.selectedSeason = 2
        service.complete(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]))
        await request.value
        XCTAssertNil(presenter.season)
        XCTAssertTrue(presenter.progress.seasons.isEmpty)
        XCTAssertFalse(presenter.isLoadingSeason)
    }

    func testCancelledSeasonDoesNotPublishAndCanReload() async {
        let store = await makeStore()
        let service = ControlledEpisodeService()
        let presenter = EpisodePresenterImpl(title: title, store: store, service: service)
        presenter.selectedSeason = 1
        let requested = expectation(description: "Season requested")
        service.onRequest = { requested.fulfill() }
        let request = Task { await presenter.loadSeason() }
        await fulfillment(of: [requested], timeout: 2)
        request.cancel()
        service.complete(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]))
        await request.value
        XCTAssertNil(presenter.season)
        XCTAssertNil(presenter.error)
        XCTAssertFalse(presenter.isLoadingSeason)
        let retried = expectation(description: "Season requested again")
        service.onRequest = { retried.fulfill() }
        let retry = Task { await presenter.loadSeason() }
        await fulfillment(of: [retried], timeout: 2)
        service.complete(EpisodeSeason(seasonNumber: 1, name: "One", episodes: [episode(1)]))
        await retry.value
        XCTAssertEqual(presenter.season?.episodes.count, 1)
    }

    func testUnsavedShowCanStartTrackingWithoutLosingMetadata() async {
        let store = WatchLibraryStoreImpl(repository: EpisodeRepositoryMock(), artwork: EpisodeArtworkMock())
        await store.load()
        let presenter = EpisodePresenterImpl(title: title, store: store, service: EpisodeServiceMock())
        await presenter.loadCatalog()
        XCTAssertFalse(presenter.isSaved)
        await presenter.saveAndStartTracking()
        XCTAssertEqual(store.entry(for: title)?.status, .watching)
        XCTAssertEqual(presenter.selectedSeason, 1)
        XCTAssertNil(presenter.actionError)
    }

    func testServiceRejectsMismatchedSeasonAndDeduplicatesEpisodes() async throws {
        let invalid = Data(#"{"season_number":2,"name":"Wrong","episodes":[]}"#.utf8)
        let badService = EpisodeServiceImpl(requestManager: DefaultRequestManager(apiManager: EpisodeAPIStub(data: invalid)))
        do {
            _ = try await badService.season(seriesID: 1, number: 1)
            XCTFail("Mismatched season must fail")
        } catch { XCTAssertTrue(error is EpisodeProgressError) }
        let duplicate = Data(#"{"season_number":1,"name":"One","episodes":[{"season_number":1,"episode_number":2,"name":"Second"},{"season_number":1,"episode_number":1,"name":"First"},{"season_number":1,"episode_number":1,"name":"Duplicate"}]}"#.utf8)
        let service = EpisodeServiceImpl(requestManager: DefaultRequestManager(apiManager: EpisodeAPIStub(data: duplicate)))
        let result = try await service.season(seriesID: 1, number: 1)
        XCTAssertEqual(result.episodes.map(\.episodeNumber), [1, 2])
        XCTAssertEqual(result.episodes.first?.name, "First")
    }

    private func makeStore(repository: WatchLibraryRepository = EpisodeRepositoryMock()) async -> WatchLibraryStoreImpl {
        let store = WatchLibraryStoreImpl(repository: repository, artwork: EpisodeArtworkMock())
        await store.load()
        await store.setStatus(.watching, for: title)
        return store
    }

    private func episode(_ number: Int, airDate: String? = "2020-01-01") -> EpisodeRecord {
        EpisodeRecord(seasonNumber: 1, episodeNumber: number, name: "Episode \(number)", airDate: airDate)
    }
}

private actor EpisodeRepositoryMock: WatchLibraryRepository {
    private var document = WatchLibraryDocument(importedFavorites: true)
    private var fail = false
    func load() async throws -> WatchLibraryDocument { document }
    func failSaves() { fail = true }
    func save(_ document: WatchLibraryDocument) async throws {
        if fail { throw CocoaError(.fileWriteNoPermission) }
        self.document = document
    }
}

private struct EpisodeArtworkMock: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}

@MainActor
private final class EpisodeServiceMock: EpisodeService {
    var requests = 0
    var shouldFail = false
    func seasons(seriesID: Int) async throws -> [EpisodeSeasonSummary] {
        requests += 1
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return [EpisodeSeasonSummary(seasonNumber: 1, name: "One")]
    }
    func season(seriesID: Int, number: Int) async throws -> EpisodeSeason {
        requests += 1
        if shouldFail { throw URLError(.notConnectedToInternet) }
        return EpisodeSeason(seasonNumber: number, name: "One", episodes: [])
    }
}

@MainActor
private final class ControlledEpisodeService: EpisodeService {
    var onRequest: (() -> Void)?
    private var continuation: CheckedContinuation<EpisodeSeason, Error>?
    func seasons(seriesID: Int) async throws -> [EpisodeSeasonSummary] { [] }
    func season(seriesID: Int, number: Int) async throws -> EpisodeSeason {
        try await withCheckedThrowingContinuation {
            continuation = $0
            onRequest?()
        }
    }
    func complete(_ season: EpisodeSeason) {
        continuation?.resume(returning: season)
        continuation = nil
    }
}

private struct EpisodeAPIStub: APIManager {
    let data: Data
    func initRequest(with request: NetworkRequest) async throws -> Data { data }
}
