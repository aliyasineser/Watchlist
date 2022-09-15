//
//  MovieListInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

class MovieListInteractor {

    let requestManager: RequestManager

    let popularMoviesFetcher: MovieFetcher
    let comingSoonMoviesFetcher: MovieFetcher
    let mostRecentMoviesFetcher: MovieFetcher

    let popularSeriesFetcher: TVSerieFetcher
    let airingTodaySeriesFetcher: TVSerieFetcher
    let onTheAirSeriesFetcher: TVSerieFetcher

    init(requestManager: RequestManager) {
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
