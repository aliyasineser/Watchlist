import Foundation

/// Composition boundary for root features. Each feature receives its own pagination state.
@MainActor
protocol AppDependencies {
    func makeDiscoverPresenter() -> DiscoverDefaultPresenter
    func makeSearchPresenter() -> SearchPresenterImpl
    func makeArtistPresenter() -> ArtistDefaultPresenter
    func makeFavoritesPresenter() -> FavoritesDefaultPresenter
}

@MainActor
struct AppDependenciesImpl: AppDependencies {
    func makeSearchPresenter() -> SearchPresenterImpl {
        SearchPresenterImpl(service: SearchServiceImpl(), history: RecentSearchStoreImpl())
    }

    func makeDiscoverPresenter() -> DiscoverDefaultPresenter {
        DiscoverDefaultPresenter(DefaultMediaInteractor())
    }

    func makeArtistPresenter() -> ArtistDefaultPresenter {
        ArtistDefaultPresenter(DefaultArtistInteractor())
    }

    func makeFavoritesPresenter() -> FavoritesDefaultPresenter {
        FavoritesDefaultPresenter(DefaultFavoritesInteractor())
    }
}

#if DEBUG
/// Offline root features keep navigation smoke tests independent of TMDB and local favorites.
@MainActor
struct UITestAppDependencies: AppDependencies {
    func makeSearchPresenter() -> SearchPresenterImpl {
        SearchPresenterImpl(service: EmptySearchService(), history: EmptyRecentSearchStore())
    }

    func makeDiscoverPresenter() -> DiscoverDefaultPresenter {
        DiscoverDefaultPresenter(EmptyMediaInteractor())
    }

    func makeArtistPresenter() -> ArtistDefaultPresenter {
        ArtistDefaultPresenter(EmptyArtistInteractor())
    }

    func makeFavoritesPresenter() -> FavoritesDefaultPresenter {
        if ProcessInfo.processInfo.arguments.contains("--ui-testing-favorites") {
            return FavoritesDefaultPresenter(SeededFavoritesInteractor())
        }
        return FavoritesDefaultPresenter(EmptyFavoritesInteractor())
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

private struct EmptyFavoritesInteractor: FavoritesInteractor {
    func getFavoriteArtists() async throws -> [ArtistDetail] { [] }
    func getFavoriteMovies() async throws -> [Watchable] { [] }
    func getFavoriteSeries() async throws -> [Watchable] { [] }
}
private struct SeededFavoritesInteractor: FavoritesInteractor {
    func getFavoriteArtists() async throws -> [ArtistDetail] { [ArtistDetail.mock] }
    func getFavoriteMovies() async throws -> [Watchable] {
        [
            MovieDetail.mock,
            Movie(id: 2, title: "Another saved movie", genreIDS: [], popularity: 1, video: false)
        ]
    }
    func getFavoriteSeries() async throws -> [Watchable] { [TvDetail.mock] }
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
#endif
