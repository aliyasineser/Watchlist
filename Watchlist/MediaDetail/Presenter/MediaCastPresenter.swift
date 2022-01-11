//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import TMDBSwift

class MediaCastPresenter: ObservableObject {
    private let interactor: MediaCastInteractor
    @Published var artists: [CastMemberEntity]
    
    var id: Int
    var mediaType: MediaType
    
    init(_ interactor: MediaCastInteractor, id: Int, mediaType: MediaType) {
        self.id = id
        self.mediaType = mediaType
        self.interactor = interactor
        self.artists = [CastMemberEntity]()
    
    }
    
    
//
//    func loadArtists() -> Void {
//        interactor.fetchArtists({ (artists) in
//            artists.forEach { (artist) in
//                if let name = artist.name {
//                    self.artists.append(ArtistEntity(artistId: artist.id, imageUrl: artist.getPosterUrl(), name: name))
//                }
//            }
//        })
//    }
//
//
    func loadArtists() -> Void {
        interactor.fetchCast(self.id, mediaType: self.mediaType, completion: { (artists) in
            self.artists = artists
            
        })
    }
    
}
