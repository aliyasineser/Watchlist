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
        if mediaType == .movie {
            let movieCredits = await movieService.fetchMovieCredits(id: id)
            movieCredits?.cast.forEach({ cast in
                if let character = cast.character {
                    self.artists.append(CastMemberEntity(id: cast.id, cast_id: cast.castID, character: character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
                }
            })
            return self.artists
            
        } else {
            let serieCredits = await tvService.fetchTVCredits(id: id)
            serieCredits?.cast.forEach({ cast in
                if let character = cast.character {
                    self.artists.append(CastMemberEntity(id: cast.id, cast_id: nil, character: character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
                }
                
            })
            return self.artists
        }
    }
    
}
