//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
class ArtistPresenter: ObservableObject {
    private let interactor: ArtistInteractor
    @Published var artists: [ArtistEntity]
    
    init(_ interactor: ArtistInteractor) {
        self.interactor = interactor
        self.artists = [ArtistEntity]()
    }
    
    func loadArtists() -> Void {
        Task {
            let artists = await interactor.fetchArtists()
            artists.forEach { (artist) in
                self.artists.append(ArtistEntity(artistId: artist.id, imageUrl: artist.getPosterUrl(), name: artist.name))
            }
        }
    }
}
