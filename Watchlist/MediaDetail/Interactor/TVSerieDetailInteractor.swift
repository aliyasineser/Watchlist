//
//  TVSerieDetailInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation

protocol TVSerieDetailInteractor {
    func getMediaDetail(_ id: Int ) async throws -> WatchableDetail?
}

final class DefaultTVSerieDetailInteractor: TVSerieDetailInteractor {

    private let tvService: MediaService = TVService.shared

    func getMediaDetail(_ id: Int ) async throws -> WatchableDetail? {
        return try await tvService.fetchMediaDetails(id: id)
    }
}

final class TVSerieDetailInteractorStub: TVSerieDetailInteractor {

    func getMediaDetail(_ id: Int ) async throws -> WatchableDetail? {
        return MovieDetail.mock
    }
}
