//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import TMDBSwift

class MovieCastPresenter: ObservableObject {
    private let interactor: MediaCastInteractor
    @Published var artists: [ArtistEntity]
    
    init(_ interactor: MediaCastInteractor) {
        self.interactor = interactor
        self.artists = [ArtistEntity]()
    }
    
    func loadArtists() -> Void {
        interactor.fetchArtists({ (artists) in
            artists.forEach { (artist) in
                if let name = artist.name {
                    self.artists.append(ArtistEntity(artistId: artist.id, imageUrl: artist.getPosterUrl(), name: name))
                }
            }
        })
    }
}
