//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

class MediaCastInteractor {
    var artists: [CastMemberEntity]
    private var artistsPageCount: Int
    
    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())
    
    init() {
        self.artists = []
        self.artistsPageCount = 0
    }
    
    func fetchCast(_ id: Int, mediaType: MediaType) async -> [CastMemberEntity] {
        self.artists.removeAll()
        var credits: Credits? = nil
        switch mediaType {
        case .tv:
            credits = await tvService.fetchTVCredits(id: id)
        case .movie:
            credits = await movieService.fetchMovieCredits(id: id)
        }
        credits?.cast.forEach({ cast in
            if let character = cast.character {
                self.artists.append(CastMemberEntity(id: cast.id, cast_id: nil, character: character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
            }
        })
        return self.artists
    }
    
}
