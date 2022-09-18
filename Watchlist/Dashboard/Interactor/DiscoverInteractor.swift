//
//  DiscoverInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation

protocol DiscoverInteractor {
    func fetchNextPopularPageAsFullList() async -> [Media]
    func fetchNextMostRecentPageAsFullList() async -> [Media]
    func fetchNextUpcomingPageAsFullList() async -> [Media]
    func fetcthAiringTodayPageAsFullList() async -> [Media]
    func fetcthOnTheAirPageAsFullList() async -> [Media]
    func fetcthTopRatedPageAsFullList() async -> [Media]
}

final class DefaultDiscoverInteractor: DiscoverInteractor {

    let requestManager: RequestManagerProtocol

    let popularMoviesFetcher: MovieFetcher
    let comingSoonMoviesFetcher: MovieFetcher
    let mostRecentMoviesFetcher: MovieFetcher

    let popularSeriesFetcher: TVSerieFetcher
    let airingTodaySeriesFetcher: TVSerieFetcher
    let onTheAirSeriesFetcher: TVSerieFetcher

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager

        self.popularMoviesFetcher = MovieFetcher(for: .popular, requestManager: requestManager)
        self.comingSoonMoviesFetcher = MovieFetcher(for: .comingSoonMovies, requestManager: requestManager)
        self.mostRecentMoviesFetcher = MovieFetcher(for: .mostRecentMovies, requestManager: requestManager)

        self.popularSeriesFetcher = TVSerieFetcher(for: .popular, requestManager: requestManager)
        self.airingTodaySeriesFetcher = TVSerieFetcher(for: .airingTodaySeries, requestManager: requestManager)
        self.onTheAirSeriesFetcher = TVSerieFetcher(for: .onTheAirSeries, requestManager: requestManager)
    }

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
    func fetcthAiringTodayPageAsFullList() async -> [Media] {
        return await airingTodaySeriesFetcher.fetchWithNextPage()
    }

    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList() async -> [Media] {
        return await onTheAirSeriesFetcher.fetchWithNextPage()
    }
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList() async -> [Media] {
        return await popularSeriesFetcher.fetchWithNextPage()
    }

}

final class DiscoverInteractorStub: DiscoverInteractor {
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
    func fetcthAiringTodayPageAsFullList() async -> [Media] { getMediaList() }
    func fetcthOnTheAirPageAsFullList() async -> [Media] { getMediaList() }
    func fetcthTopRatedPageAsFullList() async -> [Media] { getMediaList() }
}
