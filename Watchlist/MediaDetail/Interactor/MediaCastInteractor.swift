//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

protocol MediaCastInteractor {
    func fetchCast(_ id: Int) async -> [CastMemberEntity]
}

final class DefaultMediaCastInteractor: MediaCastInteractor {
    var artists: [CastMemberEntity] = []
    private let mediaService: MediaService

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func fetchCast(_ id: Int) async -> [CastMemberEntity] {
        self.artists.removeAll()
        var credits: Credits?
        credits = await mediaService.fetchMediaCredits(id: id)

        credits?.cast.forEach({ cast in
            if let character = cast.character {
                self.artists.append(
                    CastMemberEntity(
                        id: cast.id,
                        castId: nil,
                        character: character,
                        order: cast.order,
                        name: cast.getTitle(),
                        imageUrl: cast.getPosterUrl()
                    )
                )
            }
        })
        return self.artists
    }
}

final class MediaCastInteractorStub: MediaCastInteractor {
    func fetchCast(_ id: Int) async -> [CastMemberEntity] {
        var casts: [CastMemberEntity] = []
        for _ in 0..<9 {
            casts.append(.mock)
        }
        return casts
    }
}
