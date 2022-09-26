//
//  CastInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

protocol CastInteractor {
    func fetchCast(_ id: Int) async -> [CastMemberEntity]
}

final class DefaultCastInteractor: CastInteractor {

    private var artists: [CastMemberEntity]
    private let mediaService: MediaService

    init(mediaService: MediaService) {
        self.artists = []
        self.mediaService = mediaService
    }

    func fetchCast(_ id: Int) async -> [CastMemberEntity] {

        self.artists.removeAll()
        var credits: Credits?

        credits = await mediaService.fetchMediaCredits(id: id)
        guard let credits = credits else { return self.artists }
        credits.cast
            .filter { $0.castID != nil && $0.character != nil }
            .forEach {
                self.artists.append(
                    CastMemberEntity(
                        id: $0.id,
                        castId: $0.castID,
                        character: $0.character!,
                        order: $0.order,
                        name: $0.getTitle(),
                        imageUrl: $0.getPosterUrl()
                    )
                )
            }
        return self.artists
    }
}

final class CastInteractorStub: CastInteractor {
    func fetchCast(_ id: Int) async -> [CastMemberEntity] {
        var casts: [CastMemberEntity] = []
        for index in 0..<9 {
            casts.append(
                CastMemberEntity(
                    id: index,
                    castId: index,
                    character: "Character \(index) Name",
                    name: "Cast \(index) Name",
                    imageUrl: ""
                )
            )
        }
        return casts
    }
}
