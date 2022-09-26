//
//  CastInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

protocol CastInteractor {
    func fetchCast(_ id: Int) async -> [Cast]
}

final class DefaultCastInteractor: CastInteractor {

    private var credits: [Cast]
    private let mediaService: MediaService

    init(mediaService: MediaService) {
        self.credits = []
        self.mediaService = mediaService
    }

    func fetchCast(_ id: Int) async -> [Cast] {

        self.credits.removeAll()
        var credits: Credits?

        credits = await mediaService.fetchMediaCredits(id: id)
        guard let credits = credits else { return self.credits }
        let filteredCredits = credits.cast.filter { $0.castID != nil && $0.character != nil }
        self.credits.append(contentsOf: filteredCredits)
        return self.credits
    }
}

final class CastInteractorStub: CastInteractor {
    func fetchCast(_ id: Int) async -> [Cast] {
        var casts: [Cast] = []
        for _ in 0..<9 {
            casts.append(
                Cast.mock
            )
        }
        return casts
    }
}
