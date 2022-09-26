//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

protocol MediaCastInteractor {
    func fetchCast(_ id: Int) async -> [Cast]
}

final class DefaultMediaCastInteractor: MediaCastInteractor {
    private let mediaService: MediaService

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func fetchCast(_ id: Int) async -> [Cast] {
        var credits: Credits?
        credits = await mediaService.fetchMediaCredits(id: id)
        return credits?.cast ?? []
    }
}

final class MediaCastInteractorStub: MediaCastInteractor {
    func fetchCast(_ id: Int) async -> [Cast] {
        var casts: [Cast] = []
        for _ in 0..<9 {
            casts.append(.mock)
        }
        return casts
    }
}
