//
//  MovieDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation

protocol MediaDetailInteractor {
    func getMovieDetail(_ id: Int) async -> MediaDetail?
    func getTvDetail(_ id: Int ) async -> MediaDetail?
}

final class DefaultMediaDetailInteractor: MediaDetailInteractor {

    private let movieService: MovieService
    private let tvService: TVService

    init(requestManager: RequestManager) {
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

final class MediaDetailInteractorStub: MediaDetailInteractor {
    func getMovieDetail(_ id: Int) async -> MediaDetail? {
        return .mock
    }

    func getTvDetail(_ id: Int ) async -> MediaDetail? {
        return .mock
    }
}
