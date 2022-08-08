//
//  MovieDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation

class MediaDetailInteractor {

    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())

    func getMovieDetail(_ id: Int) async -> MediaDetail? {
        return await movieService.fetchMovieDetail(id: id)
    }

    func getTvDetail(_ id: Int ) async -> MediaDetail? {
        return await tvService.fetchTVDetails(id: id)
    }
}
