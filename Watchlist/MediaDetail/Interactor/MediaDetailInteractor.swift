//
//  MovieDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation

class MediaDetailInteractor {

    private let movieService: MovieService
    private let tvService: TVService

    init(requestManager: RequestManagerProtocol) {
        self.movieService = MovieService(requestManager: requestManager)
        self.tvService = TVService(requestManager: requestManager)
    }

    func getMovieDetail(_ id: Int) async -> MediaDetail? {
        return await movieService.fetchMovieDetail(id: id)
    }

    func getTvDetail(_ id: Int ) async -> MediaDetail? {
        return await tvService.fetchTVDetails(id: id)
    }
}
