import XCTest
@testable import Watchlist

@MainActor
final class ContinueWatchingTests: XCTestCase {
    func testOnlyWatchingTitlesAppearAndUnairedSpecialsAreNotNext() {
        var show = entry(.tv, status: .watching)
        show.episodeProgress = progress()
        let items = ContinueWatchingStrategyImpl().items(from: [show, entry(.movie, status: .watched)], now: .now)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.nextEpisode?.id, "1-1")
        XCTAssertEqual(items.first?.subtitle, "Next: S1 E1")
        var unknown = show
        unknown.episodeProgress = nil
        XCTAssertNil(ContinueWatchingStrategyImpl().items(from: [unknown], now: .now).first?.actionTitle)
    }

    func testEpisodeCheckOffAndUndoPreserveRatingAndShowStatus() async {
        var show = entry(.tv, status: .watching)
        show.personalRating = 8
        show.episodeProgress = progress()
        let store = store([show])
        await store.load()
        let presenter = ContinueWatchingPresenterImpl(store: store)
        await presenter.markWatched(show.id)
        XCTAssertEqual(presenter.items.first?.nextEpisode?.id, "1-2")
        XCTAssertEqual(store.entries.first?.personalRating, 8)
        XCTAssertEqual(store.entries.first?.status, .watching)
        await presenter.undo()
        XCTAssertEqual(presenter.items.first?.nextEpisode?.id, "1-1")
        XCTAssertFalse(presenter.canUndo)
    }

    func testMovieCompletionAndUndoAndNewerEditsAreProtected() async {
        let movie = entry(.movie, status: .watching)
        let store = store([movie])
        await store.load()
        let presenter = ContinueWatchingPresenterImpl(store: store)
        await presenter.markWatched(movie.id)
        XCTAssertTrue(presenter.items.isEmpty)
        await presenter.undo()
        XCTAssertEqual(presenter.items.count, 1)
        await presenter.markWatched(movie.id)
        await store.setRating(9, for: movie.title)
        await presenter.undo()
        XCTAssertNotNil(presenter.error)
        XCTAssertFalse(presenter.canUndo)
        XCTAssertEqual(store.entries.first?.status, .watched)
        XCTAssertEqual(store.entries.first?.personalRating, 9)
    }

    func testFailedSaveLeavesNextEpisodeAndUndoUnchanged() async {
        var show = entry(.tv, status: .watching)
        show.episodeProgress = progress()
        let repository = ContinueRepository(entries: [show])
        let store = WatchLibraryStoreImpl(repository: repository, artwork: ContinueArtwork())
        await store.load()
        await repository.failSaves()
        let presenter = ContinueWatchingPresenterImpl(store: store)
        await presenter.markWatched(show.id)
        XCTAssertEqual(presenter.items.first?.nextEpisode?.id, "1-1")
        XCTAssertFalse(presenter.canUndo)
        XCTAssertNotNil(presenter.error)
    }

    private func entry(_ type: MediaType, status: WatchStatus) -> WatchEntry {
        WatchEntry(title: SavedTitle(tmdbID: 1, mediaType: type, title: "Title"), status: status,
                   addedAt: .distantPast, updatedAt: .distantPast)
    }
    private func progress() -> SeriesProgress {
        SeriesProgress(seasons: [EpisodeSeason(seasonNumber: 1, name: "One", episodes: [
            EpisodeRecord(seasonNumber: 0, episodeNumber: 1, name: "Special", airDate: "2020-01-01"),
            EpisodeRecord(seasonNumber: 1, episodeNumber: 1, name: "First", airDate: "2020-01-01"),
            EpisodeRecord(seasonNumber: 1, episodeNumber: 2, name: "Second", airDate: "2020-01-08"),
            EpisodeRecord(seasonNumber: 1, episodeNumber: 3, name: "Future", airDate: "2999-01-01")
        ])])
    }
    private func store(_ entries: [WatchEntry]) -> WatchLibraryStoreImpl {
        WatchLibraryStoreImpl(repository: ContinueRepository(entries: entries), artwork: ContinueArtwork())
    }
}

private actor ContinueRepository: WatchLibraryRepository {
    private var document: WatchLibraryDocument
    private var fail = false
    init(entries: [WatchEntry]) { document = WatchLibraryDocument(importedFavorites: true, entries: entries) }
    func load() async throws -> WatchLibraryDocument { document }
    func failSaves() { fail = true }
    func save(_ document: WatchLibraryDocument) async throws {
        if fail { throw CocoaError(.fileWriteNoPermission) }
        self.document = document
    }
}

private struct ContinueArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
