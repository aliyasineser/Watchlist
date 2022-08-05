//
//  DiscoverInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation

class DiscoverInteractor {
    
    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())
    
    let popularMoviesFetcher: MovieFetcher = MovieFetcher(for: .popular)
    let comingSoonMoviesFetcher: MovieFetcher = MovieFetcher(for: .comingSoonMovies)
    let mostRecentMoviesFetcher: MovieFetcher = MovieFetcher(for: .mostRecentMovies)
    
    let popularSeriesFetcher: TVSerieFetcher = TVSerieFetcher(for: .popular)
    let airingTodaySeriesFetcher: TVSerieFetcher = TVSerieFetcher(for: .airingTodaySeries)
    let onTheAirSeriesFetcher: TVSerieFetcher = TVSerieFetcher(for: .onTheAirSeries)
    
    
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

