//
//  CastInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

class CastInteractor {

    private var artists: [CastMemberEntity]
    private let movieService: MovieService
    private let tvService: TVService

    init(requestManager: RequestManagerProtocol) {
        self.artists = []
        self.tvService = TVService(requestManager: requestManager)
        self.movieService = MovieService(requestManager: requestManager)
    }

    func fetchCast(_ id: Int, mediaType: MediaType) async -> [CastMemberEntity] {

        self.artists.removeAll()
        var credits: Credits?

        if mediaType == .movie {
            credits = await movieService.fetchMovieCredits(id: id)
        } else {
            credits = await movieService.fetchMovieCredits(id: id)
        }
        if let credits = credits {
            credits.cast.forEach({ cast in
                if let castId = cast.castID, let character = cast.character {
                    self.artists.append(CastMemberEntity(id: cast.id, castId: castId,
                                                         character: character, order: cast.order,
                                                         name: cast.getTitle(), imageUrl: cast.getPosterUrl()))
                }
            })
        }
        return self.artists
    }
}
