//
//  MovieListInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

class MovieListInteractor {
    
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


