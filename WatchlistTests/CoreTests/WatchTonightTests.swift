import XCTest
@testable import Watchlist

@MainActor
final class WatchTonightTests: XCTestCase {
    private let strategy = WatchSuggestionStrategyImpl()

    func testFiltersExcludeWatchedAndUnknownRuntime() {
        let entries = [entry(1, minutes: 90), entry(2, minutes: nil), entry(3, minutes: 120),
                       entry(4, minutes: 60, status: .watched), entry(5, minutes: 30, type: .tv)]
        let filter = WatchTonightFilter(genre: "Drama", maximumMinutes: 90, mediaType: .movie)
        XCTAssertEqual(strategy.matches(entries: entries, filter: filter).map(\.id), ["movie-1"])
        XCTAssertEqual(strategy.matches(entries: entries, filter: .init()).count, 4)
        XCTAssertTrue(strategy.matches(entries: entries, filter: .init(genre: "Comedy")).isEmpty)
    }

    func testOrderingIsStableAndPrioritizesOldestSaved() {
        let first = entry(1, minutes: 90)
        var newer = entry(2, minutes: 100)
        newer = WatchEntry(title: newer.title, status: .watching, addedAt: Date(timeIntervalSince1970: 20),
                           updatedAt: .now)
        XCTAssertEqual(strategy.matches(entries: [newer, first], filter: .init()).map(\.id), [first.id, newer.id])
        XCTAssertTrue(strategy.reason(for: newer).contains("Continue watching"))
        XCTAssertTrue(strategy.reason(for: entry(1, minutes: 30, type: .tv)).contains("per episode"))
    }

    func testLegacyMetadataDecodesWithoutNewFields() throws {
        let data = Data(#"{"tmdbID":1,"mediaType":"movie","title":"Legacy"}"#.utf8)
        let title = try JSONDecoder().decode(SavedTitle.self, from: data)
        XCTAssertNil(title.genreNames)
        XCTAssertNil(title.runtimeMinutes)
        XCTAssertEqual(SavedTitle(media: MovieDetail.mock).runtimeMinutes, MovieDetail.mock.runtime)
    }

    func testPickIsClearedByFilterAndRemovedTitlesCannotStayPicked() async {
        let store = WatchLibraryStoreImpl(repository: TonightRepository(), artwork: TonightArtwork())
        await store.load()
        let title = entry(1, minutes: 90).title
        await store.setStatus(.wantToWatch, for: title)
        let presenter = WatchTonightPresenterImpl(store: store, choose: { $0.first })
        presenter.pick()
        XCTAssertEqual(presenter.picked?.id, title.id)
        presenter.filter.maximumMinutes = 30
        XCTAssertNil(presenter.picked)
        presenter.pick()
        XCTAssertNil(presenter.picked)
        presenter.filter.maximumMinutes = nil
        presenter.pick()
        await store.setStatus(.watched, for: title)
        XCTAssertNil(presenter.picked)
        XCTAssertTrue(presenter.matches.isEmpty)
    }

    private func entry(_ id: Int, minutes: Int?, status: WatchStatus = .wantToWatch,
                       type: MediaType = .movie) -> WatchEntry {
        var title = SavedTitle(tmdbID: id, mediaType: type, title: "Title \(id)")
        title.runtimeMinutes = minutes
        title.genreNames = ["Drama"]
        return WatchEntry(title: title, status: status, addedAt: Date(timeIntervalSince1970: 10), updatedAt: .now)
    }
}

private actor TonightRepository: WatchLibraryRepository {
    private var document = WatchLibraryDocument(importedFavorites: true)
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct TonightArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
