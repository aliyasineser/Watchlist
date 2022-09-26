//
//  MovieDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation

protocol MovieDetailInteractor {
    func getMovieDetail(_ id: Int) async -> WatchableDetail?
}

final class DefaultMovieDetailInteractor: MovieDetailInteractor {

    private let movieService: MediaService = MovieService.shared

    func getMovieDetail(_ id: Int) async -> WatchableDetail? {
        return await movieService.fetchMediaDetails(id: id)
    }
}

final class MovieDetailInteractorStub: MovieDetailInteractor {
    func getMovieDetail(_ id: Int) async -> WatchableDetail? {
        return MovieDetail.mock
    }
}
