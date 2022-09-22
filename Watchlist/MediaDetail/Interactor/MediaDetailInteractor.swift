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

    private let movieService: MediaService = MovieService.shared
    private let tvService: MediaService = TVService.shared

    func getMovieDetail(_ id: Int) async -> MediaDetail? {
        return await movieService.fetchMediaDetails(id: id)
    }

    func getTvDetail(_ id: Int ) async -> MediaDetail? {
        return await tvService.fetchMediaDetails(id: id)
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
