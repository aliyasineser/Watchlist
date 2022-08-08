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

    let movieService = MovieService(requestManager: RequestManager())

    init(for section: MovieSection) {
        self.section = section
    }

    func fetchSinglePage() async -> [Media] {
        pageCounter += 1
        var watchables: [Watchable] = []
        switch section {
        case .popular:
            watchables =  await movieService.fetchPopularMovies(page: pageCounter)
        case .mostRecentMovies:
            watchables =  await movieService.fetchNowPlayingMovies(page: pageCounter)
        case .comingSoonMovies:
            watchables =  await movieService.fetchUpcomingMovies(page: pageCounter)
        }
        return watchables.compactMap { WatchableToMediaMapper.convert(from: $0, type: .movie) }
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
