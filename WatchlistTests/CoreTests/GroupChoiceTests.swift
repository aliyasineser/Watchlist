import XCTest
@testable import Watchlist

@MainActor
final class GroupChoiceTests: XCTestCase {
    func testNoResultsBeforeEveryViewerFinishesAndMutualMatchesAreExact() async {
        let store = await store()
        let presenter = GroupChoicePresenterImpl(store: store, choose: { $0.first })
        let original = store.document
        presenter.start()
        XCTAssertEqual(presenter.phase, .setup)
        XCTAssertNotNil(presenter.error)
        selectPair(presenter)
        presenter.start()
        presenter.vote(interested: true)
        presenter.undoVote()
        XCTAssertEqual(presenter.titleIndex, 0)
        presenter.vote(interested: true)
        presenter.vote(interested: false)
        XCTAssertEqual(presenter.phase, .handoff)
        XCTAssertTrue(presenter.ranked.isEmpty)
        XCTAssertNil(presenter.currentTitle)
        presenter.beginNextViewer()
        presenter.vote(interested: true)
        XCTAssertTrue(presenter.ranked.isEmpty)
        presenter.vote(interested: true)
        XCTAssertEqual(presenter.phase, .results)
        XCTAssertEqual(presenter.mutual.map(\.id), ["movie-1"])
        presenter.pick()
        XCTAssertEqual(presenter.picked?.id, "movie-1")
        XCTAssertEqual(store.document, original)
        presenter.reset()
        XCTAssertEqual(presenter.phase, .setup)
        XCTAssertTrue(presenter.ranked.isEmpty)
        XCTAssertNil(presenter.picked)
    }

    func testClosestMatchesAreExplicitAndAllSkippedTitlesAreNeverPicked() async {
        let presenter = GroupChoicePresenterImpl(store: await store(), choose: { $0.first })
        selectPair(presenter)
        presenter.start()
        presenter.vote(interested: true)
        presenter.vote(interested: false)
        presenter.beginNextViewer()
        presenter.vote(interested: false)
        presenter.vote(interested: true)
        XCTAssertTrue(presenter.mutual.isEmpty)
        presenter.pick()
        XCTAssertNil(presenter.picked)
        presenter.revealClosest()
        XCTAssertEqual(presenter.eligible.count, 2)
        presenter.pick()
        XCTAssertNotNil(presenter.picked)
        presenter.reset()
        presenter.start()
        for _ in 0..<2 { presenter.vote(interested: false) }
        presenter.beginNextViewer()
        for _ in 0..<2 { presenter.vote(interested: false) }
        presenter.revealClosest()
        presenter.pick()
        XCTAssertTrue(presenter.eligible.isEmpty)
        XCTAssertNil(presenter.picked)
    }

    func testClosestPicksOnlyHighestScoreWhenThereIsNoUnanimousMatch() async {
        let presenter = GroupChoicePresenterImpl(store: await store(), choose: { $0.first })
        presenter.setParticipantCount(3)
        selectPair(presenter)
        presenter.start()
        presenter.vote(interested: true)
        presenter.vote(interested: true)
        presenter.beginNextViewer()
        presenter.vote(interested: true)
        presenter.vote(interested: false)
        presenter.beginNextViewer()
        presenter.vote(interested: false)
        presenter.vote(interested: false)
        presenter.revealClosest()
        XCTAssertEqual(presenter.eligible.map(\.id), ["movie-1"])
        presenter.pick()
        XCTAssertEqual(presenter.picked?.interested, 2)
    }

    func testCustomListCanIncludeWatchedTitlesAndDeletedTitlesCannotBePicked() async throws {
        let store = await store()
        _ = await store.saveList(id: nil, name: "Rewatch", notes: "")
        let list = try XCTUnwrap(store.customLists.first)
        await store.setListMembership(true, titleID: "movie-2", listID: list.id)
        let presenter = GroupChoicePresenterImpl(store: store, choose: { $0.first })
        XCTAssertFalse(presenter.candidates.contains { $0.id == "movie-2" })
        presenter.sourceID = list.id
        XCTAssertEqual(presenter.candidates.map(\.id), ["movie-2"])
        presenter.toggleSelection("movie-2")
        presenter.start()
        presenter.vote(interested: true)
        presenter.beginNextViewer()
        presenter.vote(interested: true)
        XCTAssertEqual(presenter.mutual.count, 1)
        let title = try XCTUnwrap(store.entries.first { $0.id == "movie-2" }?.title)
        await store.remove(title)
        presenter.pick()
        XCTAssertNil(presenter.picked)
        XCTAssertTrue(presenter.ranked.isEmpty)
    }

    func testSelectionAndParticipantLimitsAndIncompleteVotes() async {
        let store = await store(movieCount: 21)
        let presenter = GroupChoicePresenterImpl(store: store)
        for index in 1...21 { presenter.toggleSelection("movie-\(index)") }
        XCTAssertEqual(presenter.selectedIDs.count, 20)
        presenter.setParticipantCount(9)
        XCTAssertEqual(presenter.participantNames.count, 2)
        presenter.setName(String(repeating: "x", count: 41), at: 0)
        presenter.start()
        XCTAssertEqual(presenter.phase, .setup)
        presenter.setName("  ", at: 0)
        presenter.start()
        XCTAssertEqual(presenter.currentParticipant, "Viewer 1")
        XCTAssertEqual(presenter.titleCount, 20)
        let titles = [SavedTitle(tmdbID: 1, mediaType: .movie, title: "Title")]
        XCTAssertTrue(GroupChoiceStrategyImpl().results(titles: titles, votes: [[true], [nil]]).isEmpty)
        XCTAssertTrue(GroupChoiceStrategyImpl().results(titles: titles, votes: [[true], []]).isEmpty)
    }

    private func selectPair(_ presenter: GroupChoicePresenterImpl) {
        presenter.toggleSelection("movie-1")
        presenter.toggleSelection("tv-1")
    }
    private func store(movieCount: Int = 2) async -> WatchLibraryStoreImpl {
        let store = WatchLibraryStoreImpl(
            repository: ChoiceRepository(movieCount: movieCount), artwork: ChoiceArtwork()
        )
        await store.load()
        return store
    }
}

private actor ChoiceRepository: WatchLibraryRepository {
    private var document: WatchLibraryDocument
    init(movieCount: Int) {
        var entries = (1...movieCount).map {
            WatchEntry(title: SavedTitle(tmdbID: $0, mediaType: .movie, title: "Movie \($0)"),
                       status: movieCount == 2 && $0 == 2 ? .watched : .wantToWatch,
                       addedAt: .distantPast, updatedAt: .distantPast)
        }
        entries.append(WatchEntry(title: SavedTitle(tmdbID: 1, mediaType: .tv, title: "Show"), status: .watching,
                                  addedAt: .distantPast, updatedAt: .distantPast))
        document = WatchLibraryDocument(importedFavorites: true, entries: entries)
    }
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct ChoiceArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
