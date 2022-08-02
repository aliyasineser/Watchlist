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
    func fetchNextPopularPageAsFullList() async -> [Movie] {
        let watchables = await popularMoviesFetcher.fetchWithNextPage()
        if let movies = watchables as? [Movie] { return movies}
        else { return [] }
    }
    
    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList() async -> [Movie] {
        let watchables = await mostRecentMoviesFetcher.fetchWithNextPage()
        if let movies = watchables as? [Movie] { return movies}
        else { return [] }
    }
    
    
    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList() async -> [Movie] {
        let watchables = await comingSoonMoviesFetcher.fetchWithNextPage()
        if let movies = watchables as? [Movie] { return movies}
        else { return [] }
    }
    
    /// Starts from the first page
    func fetcthAiringTodayPageAsFullList() async -> [TVSerie] {
        let watchables = await airingTodaySeriesFetcher.fetchWithNextPage()
        if let series = watchables as? [TVSerie] { return series}
        else { return [] }
    }
    
    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList() async -> [TVSerie] {
        let watchables = await onTheAirSeriesFetcher.fetchWithNextPage()
        if let series = watchables as? [TVSerie] { return series}
        else { return [] }
    }
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList() async -> [TVSerie] {
        let watchables = await popularSeriesFetcher.fetchWithNextPage()
        if let series = watchables as? [TVSerie] { return series}
        else { return [] }
    }
    
}


