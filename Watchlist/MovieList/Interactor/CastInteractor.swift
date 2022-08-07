//
//  CastInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation


class CastInteractor{
    
    var artists: [CastMemberEntity]
    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())
    
    init() {
        self.artists = []
    }
    
    // TODO: Change the calls
    func fetchCast(_ id: Int, mediaType: MediaType) async -> [CastMemberEntity] {
        
        self.artists.removeAll()
        var credits: Credits? = nil
        
        if mediaType == .movie {
            credits = await movieService.fetchMovieCredits(id: id)
        } else {
            credits = await movieService.fetchMovieCredits(id: id)
        }
        if let credits = credits {
            credits.cast.forEach({ cast in
                if let castId = cast.castID, let character = cast.character {
                    self.artists.append(CastMemberEntity(id: cast.id, cast_id: castId, character: character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
                }
            })
        }
        return self.artists
        
    }
    
}

