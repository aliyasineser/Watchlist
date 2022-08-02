//
//  MovieFetcher.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation


enum MovieSection {
    case popular
    case mostRecentMovies
    case comingSoonMovies
}

class MovieFetcher: Fetchable {
    
    private var movies: [Watchable] = []
    private var pageCounter: Int = 0
    private var section: MovieSection
    
    let movieService = MovieService(requestManager: RequestManager())
    
    init(for section: MovieSection) {
        self.section = section
    }
    
    func fetchSinglePage() async -> [Watchable] {
        pageCounter += 1
        switch section {
        case .popular:
            return await movieService.fetchPopularMovies(page: pageCounter)
        case .mostRecentMovies:
            return await movieService.fetchNowPlayingMovies(page: pageCounter)
        case .comingSoonMovies:
            return await movieService.fetchUpcomingMovies(page: pageCounter)
        }
    }
    
    func fetchWithNextPage() async -> [Watchable] {
        let moviesPage = await fetchSinglePage()
        self.movies.append(contentsOf: moviesPage)
        return self.movies
    }
    
    func getFetched() -> [Watchable] {
        return movies
    }
}
