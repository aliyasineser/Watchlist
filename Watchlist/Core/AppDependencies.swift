import Foundation

/// Composition boundary for root features. Each feature receives its own pagination state.
@MainActor
protocol AppDependencies {
    func makeDiscoverPresenter() -> DiscoverDefaultPresenter
    func makeWatchLibraryStore() -> WatchLibraryStoreImpl
    func makeSearchPresenter() -> SearchPresenterImpl
    func makeArtistPresenter() -> ArtistDefaultPresenter
}

@MainActor
struct AppDependenciesImpl: AppDependencies {
    func makeWatchLibraryStore() -> WatchLibraryStoreImpl { .shared }

    func makeSearchPresenter() -> SearchPresenterImpl {
        SearchPresenterImpl(service: SearchServiceImpl(), history: RecentSearchStoreImpl())
    }

    func makeDiscoverPresenter() -> DiscoverDefaultPresenter {
        DiscoverDefaultPresenter(DefaultMediaInteractor())
    }

    func makeArtistPresenter() -> ArtistDefaultPresenter {
        ArtistDefaultPresenter(DefaultArtistInteractor())
    }

}

#if DEBUG
/// Offline root features keep navigation smoke tests independent of TMDB and local favorites.
@MainActor
struct UITestAppDependencies: AppDependencies {
    func makeWatchLibraryStore() -> WatchLibraryStoreImpl {
        WatchLibraryStoreImpl(repository: MemoryWatchLibraryRepository(), artwork: EmptyArtworkCache()) {
            guard ProcessInfo.processInfo.arguments.contains("--ui-testing-favorites") else { return [] }
            var movie = SavedTitle(media: MovieDetail.mock)
            movie.posterURL = nil
            return [
                movie,
                SavedTitle(tmdbID: 2, mediaType: .movie, title: "Another saved movie"),
                SavedTitle(tmdbID: 1, mediaType: .tv, title: "Saved series")
            ]
        }
    }

    func makeSearchPresenter() -> SearchPresenterImpl {
        SearchPresenterImpl(service: EmptySearchService(), history: EmptyRecentSearchStore())
    }

    func makeDiscoverPresenter() -> DiscoverDefaultPresenter {
        DiscoverDefaultPresenter(EmptyMediaInteractor())
    }

    func makeArtistPresenter() -> ArtistDefaultPresenter {
        ArtistDefaultPresenter(EmptyArtistInteractor())
    }

}

private struct EmptyMediaInteractor: MediaInteractor {
    func fetchNextPopularPageAsFullList() async throws -> [Watchable] { [] }
    func fetchNextMostRecentPageAsFullList() async throws -> [Watchable] { [] }
    func fetchNextUpcomingPageAsFullList() async throws -> [Watchable] { [] }
    func fetcthNextAiringTodayPageAsFullList() async throws -> [Watchable] { [] }
    func fetcthNextOnTheAirPageAsFullList() async throws -> [Watchable] { [] }
    func fetcthNextTopRatedPageAsFullList() async throws -> [Watchable] { [] }
}

private struct EmptyArtistInteractor: ArtistInteractor {
    func fetchArtists() async -> [Artist] { [] }
}

private struct EmptySearchService: SearchService {
    func search(query: String, category: SearchCategory, page: Int) async throws -> SearchPage {
        SearchPage(results: [], page: page, totalPages: 0)
    }
}

private final class EmptyRecentSearchStore: RecentSearchStore {
    var queries: [String] = []
    func remember(_ query: String) { queries = [query] }
    func clear() { queries = [] }
}
private actor MemoryWatchLibraryRepository: WatchLibraryRepository {
    private var document = WatchLibraryDocument()
    init() {
        if ProcessInfo.processInfo.arguments.contains("--ui-testing-favorites") {
            let episodes = [
                EpisodeRecord(seasonNumber: 1, episodeNumber: 1, name: "Pilot", airDate: "2020-01-01"),
                EpisodeRecord(seasonNumber: 1, episodeNumber: 2, name: "The next chapter", airDate: "2020-01-08")
            ]
            let progress = SeriesProgress(
                catalog: [EpisodeSeasonSummary(seasonNumber: 1, name: "Season 1")],
                seasons: [EpisodeSeason(seasonNumber: 1, name: "Season 1", episodes: episodes)]
            )
            document.entries = [WatchEntry(
                title: SavedTitle(tmdbID: 1, mediaType: .tv, title: "Saved series"), status: .watching,
                episodeProgress: progress, addedAt: .now, updatedAt: .now
            )]
        }
    }
    func load() async throws -> WatchLibraryDocument { document }
    func save(_ document: WatchLibraryDocument) async throws { self.document = document }
}

private struct EmptyArtworkCache: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}
#endif
