import Foundation

/// Composition boundary for root features. Each feature receives its own pagination state.
@MainActor
protocol AppDependencies {
    func makeDiscoverPresenter() -> DiscoverDefaultPresenter
    func makeArtistPresenter() -> ArtistDefaultPresenter
    func makeFavoritesPresenter() -> FavoritesDefaultPresenter
}

@MainActor
struct AppDependenciesImpl: AppDependencies {
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
    func makeDiscoverPresenter() -> DiscoverDefaultPresenter {
        DiscoverDefaultPresenter(EmptyMediaInteractor())
    }

    func makeArtistPresenter() -> ArtistDefaultPresenter {
        ArtistDefaultPresenter(EmptyArtistInteractor())
    }

    func makeFavoritesPresenter() -> FavoritesDefaultPresenter {
        FavoritesDefaultPresenter(EmptyFavoritesInteractor())
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
#endif
