//
//  TVSerieDetailInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation

protocol TVSerieDetailInteractor {
    func getDetail(_ id: Int ) async -> Watchable?
}

final class DefaultTVSerieDetailInteractor: TVSerieDetailInteractor {

    private let tvService: MediaService = TVService.shared

    func getDetail(_ id: Int ) async -> Watchable? {
        return await tvService.fetchMediaDetails(id: id)
    }
}

final class TVSerieDetailInteractorStub: TVSerieDetailInteractor {

    func getDetail(_ id: Int ) async -> Watchable? {
        return MovieDetail.mock
    }
}
