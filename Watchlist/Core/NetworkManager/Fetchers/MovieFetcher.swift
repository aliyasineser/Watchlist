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

    private var movies: [Media] = []
    private var pageCounter: Int = 0
    private var section: MovieSection

    private let movieService: MovieService

    init(for section: MovieSection, requestManager: RequestManager) {
        self.section = section
        self.movieService = MovieService(requestManager: requestManager)
    }

    func fetchSinglePage() async -> [Media] {
        pageCounter += 1
        var watchables: [Media] = []
        switch section {
        case .popular:
            watchables =  await movieService.fetchMedia(request: MovieRequest.getPopularMovies(page: pageCounter))
        case .mostRecentMovies:
            watchables =  await movieService.fetchMedia(request: MovieRequest.getPopularMovies(page: pageCounter))
        case .comingSoonMovies:
            watchables =  await movieService.fetchMedia(request: MovieRequest.getPopularMovies(page: pageCounter))
        }
        return watchables
    }

    func fetchWithNextPage() async -> [Media] {
        let moviesPage = await fetchSinglePage()
        self.movies.append(contentsOf: moviesPage)
        return self.movies
    }

    func getFetched() -> [Media] {
        return movies
    }
}
