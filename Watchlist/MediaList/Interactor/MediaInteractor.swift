//
//  MediaInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

protocol MediaInteractor {
    func fetchNextPopularPageAsFullList() async -> [Media]
    func fetchNextMostRecentPageAsFullList() async -> [Media]
    func fetchNextUpcomingPageAsFullList() async -> [Media]
    func fetcthNextAiringTodayPageAsFullList() async -> [Media]
    func fetcthNextOnTheAirPageAsFullList() async -> [Media]
    func fetcthNextTopRatedPageAsFullList() async -> [Media]
}

final class DefaultMediaInteractor: MediaInteractor {

    let popularMoviesFetcher: Fetchable = MediaFetcher(strategy: PopularMoviesFetchStrategy(),
                                                       service: MovieService.shared
    )
    let comingSoonMoviesFetcher: Fetchable = MediaFetcher(strategy: UpcomingMoviesFetchStrategy(),
                                                          service: MovieService.shared
    )
    let mostRecentMoviesFetcher: Fetchable = MediaFetcher(strategy: NowPlayingMoviesFetchStrategy(),
                                                          service: MovieService.shared
    )

    let popularSeriesFetcher: Fetchable = MediaFetcher(strategy: PopularSeriesFetchStrategy(),
                                                       service: TVService.shared
    )
    let airingTodaySeriesFetcher: Fetchable = MediaFetcher(strategy: AiringTodaySeriesFetchStrategy(),
                                                           service: TVService.shared
    )
    let onTheAirSeriesFetcher: Fetchable = MediaFetcher(strategy: OnTheAirSeriesFetchStrategy(),
                                                        service: TVService.shared
    )

    /// Starts from the first page
    func fetchNextPopularPageAsFullList() async -> [Media] {
        return await popularMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList() async -> [Media] {
        return await mostRecentMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList() async -> [Media] {
        return await comingSoonMoviesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetcthNextAiringTodayPageAsFullList() async -> [Media] {
        return await airingTodaySeriesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetcthNextOnTheAirPageAsFullList() async -> [Media] {
        return await onTheAirSeriesFetcher.fetchWithNextPage()
    }
    /// Starts from the first page
    func fetcthNextTopRatedPageAsFullList() async -> [Media] {
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

    func fetchNextPopularPageAsFullList() async -> [Media] { getMediaList() }
    func fetchNextMostRecentPageAsFullList() async -> [Media] { getMediaList() }
    func fetchNextUpcomingPageAsFullList() async -> [Media] { getMediaList() }
    func fetcthNextAiringTodayPageAsFullList() async -> [Media] { getMediaList() }
    func fetcthNextOnTheAirPageAsFullList() async -> [Media] { getMediaList() }
    func fetcthNextTopRatedPageAsFullList() async -> [Media] { getMediaList() }
}
