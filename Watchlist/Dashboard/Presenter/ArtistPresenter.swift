//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import TMDBSwift

class ArtistPresenter: ObservableObject {
    private let interactor: ArtistInteractor
    @Published var artists: [ArtistEntity]
    
    init(_ interactor: ArtistInteractor) {
        self.interactor = interactor
        self.artists = [ArtistEntity]()
    }
    
    func loadArtists() -> Void {
        interactor.fetchArtists({ (artists) in
            artists.forEach { (artist) in
                if let name = artist.name {
                    self.artists.append(ArtistEntity( imageUrl: artist.getPosterUrl(), name: name))
                }
            }
        })
    }
}
