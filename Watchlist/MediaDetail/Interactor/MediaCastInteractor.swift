//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import TMDBSwift

class MediaCastInteractor {
    var artists: [CastMemberEntity]
    private var artistsPageCount: Int
    
    init() {
        self.artists = []
        self.artistsPageCount = 0
    }
    
//    func fetchArtists(_ completion: @escaping (([PersonResults])-> Void)) -> Void {
//        self.artistsPageCount += 1
//        PersonMDB.popular(page: self.artistsPageCount) { (ret, artistResults) in
//            if let artists = artistResults {
//                self.artists.append(contentsOf: artists)
//                completion(artists)
//            }
//        }
//    }
//
    func fetchCast(_ id: Int, mediaType: MediaType, completion: @escaping (([CastMemberEntity])-> Void)) -> Void {
        self.artists.removeAll()
        if mediaType == .movie {
            MovieMDB.credits(movieID: id) { ret, movieCredits in
                movieCredits?.cast.forEach({ cast in
                        self.artists.append(CastMemberEntity(id: cast.id, cast_id: cast.cast_id, character: cast.character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
                })
                completion(self.artists)
            }
        } else {
            TVMDB.credits(tvShowID: id) { ret, movieCredits in
                movieCredits?.cast.forEach({ cast in
                    self.artists.append(CastMemberEntity(id: cast.id, cast_id: nil, character: cast.character, order: cast.order, name: cast.name, imageUrl: cast.getPosterUrl()))
                })
                completion(self.artists)
            }
            
        }
        
    }
    
    
}
