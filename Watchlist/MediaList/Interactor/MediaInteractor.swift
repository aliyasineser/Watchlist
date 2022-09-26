//
//  MediaInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

protocol MediaInteractor {
    func fetchNextPopularPageAsFullList() async -> [Watchable]
    func fetchNextMostRecentPageAsFullList() async -> [Watchable]
    func fetchNextUpcomingPageAsFullList() async -> [Watchable]
    func fetcthNextAiringTodayPageAsFullList() async -> [Watchable]
    func fetcthNextOnTheAirPageAsFullList() async -> [Watchable]
    func fetcthNextTopRatedPageAsFullList() async -> [Watchable]
}

final class DefaultMediaInteractor: MediaInteractor {

    let popularMoviesFetcher: Fetchable = MediaFetcher(
        strategy: PopularMoviesFetchStrategy(),
        service: MovieService.shared
    )
    let comingSoonMoviesFetcher: Fetchable = MediaFetcher(
        strategy: UpcomingMoviesFetchStrategy(),
        service: MovieService.shared
    )
    let mostRecentMoviesFetcher: Fetchable = MediaFetcher(
        strategy: NowPlayingMoviesFetchStrategy(),
        service: MovieService.shared
    )

    let popularSeriesFetcher: Fetchable = MediaFetcher(
        strategy: PopularSeriesFetchStrategy(),
        service: TVService.shared
    )
    let airingTodaySeriesFetcher: Fetchable = MediaFetcher(
        strategy: AiringTodaySeriesFetchStrategy(),
        service: TVService.shared
    )
    let onTheAirSeriesFetcher: Fetchable = MediaFetcher(
        strategy: OnTheAirSeriesFetchStrategy(),
        service: TVService.shared
    )

    /// Starts from the first page
    func fetchNextPopularPageAsFullList() async -> [Watchable] {
        return await popularMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList() async -> [Watchable] {
        return await mostRecentMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList() async -> [Watchable] {
        return await comingSoonMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetcthNextAiringTodayPageAsFullList() async -> [Watchable] {
        return await airingTodaySeriesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetcthNextOnTheAirPageAsFullList() async -> [Watchable] {
        return await onTheAirSeriesFetcher.fetchWithNextPage()
    }
    /// Starts from the first page
    func fetcthNextTopRatedPageAsFullList() async -> [Watchable] {
        return await popularSeriesFetcher.fetchWithNextPage()
    }

}

final class MediaInteractorStub: MediaInteractor {
    private func getMediaList() -> [Media] {
        var mediaList: [Media] = []
        for _ in 0..<9 {
            mediaList.append(Media.mock)
        }
        return mediaList
    }

    func fetchNextPopularPageAsFullList() async -> [Watchable] { getMediaList() }
    func fetchNextMostRecentPageAsFullList() async -> [Watchable] { getMediaList() }
    func fetchNextUpcomingPageAsFullList() async -> [Watchable] { getMediaList() }
    func fetcthNextAiringTodayPageAsFullList() async -> [Watchable] { getMediaList() }
    func fetcthNextOnTheAirPageAsFullList() async -> [Watchable] { getMediaList() }
    func fetcthNextTopRatedPageAsFullList() async -> [Watchable] { getMediaList() }
}
