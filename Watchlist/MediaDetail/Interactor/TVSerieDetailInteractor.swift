//
//  TVSerieDetailInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation

protocol TVSerieDetailInteractor {
    func getDetail(_ id: Int ) async -> WatchableDetail?
}

final class DefaultTVSerieDetailInteractor: TVSerieDetailInteractor {

    private let tvService: MediaService = TVService.shared

    func getDetail(_ id: Int ) async -> WatchableDetail? {
        return await tvService.fetchMediaDetails(id: id)
    }
}

final class TVSerieDetailInteractorStub: TVSerieDetailInteractor {

    func getDetail(_ id: Int ) async -> WatchableDetail? {
        return MovieDetail.mock
    }
}
