//
//  CastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

@MainActor
class CastPresenter: ObservableObject {
    
    private let interactor: CastInteractor
    @Published var artists: [CastEntity]
    
    var id: Int
    var mediaType: MediaType
    
    init(_ interactor: CastInteractor, id: Int, mediaType: MediaType) {
        self.id = id
        self.mediaType = mediaType
        self.interactor = interactor
        self.artists = [CastEntity]()
    }
    
    // TODO: Change how it works, depends on what asked from the view
    //    func loadArtists() -> Void {
    //        interactor.fetchCast(self.id, mediaType: self.mediaType, completion: { (artists) in
    //            self.artists = artists.map { (artist) -> CastEntity in
    //                return CastEntity( imageUrl: artist.imageUrl, name: artist.name, character: artist.character)
    //            }
    //
    //        })
    //    }
    
}
