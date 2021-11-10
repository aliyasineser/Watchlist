//
//  ArtistDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation
import TMDBSwift

class ArtistDetailPresenter: ObservableObject {
    var interactor: ArtistDetailInteractor
    @Published var artistDetail: ArtistDetailEntity
    @Published var artistImages: [ArtistImageEntity]
    @Published var artistCredits: [MediaCreditEntity]
    
    init(interactor: ArtistDetailInteractor) {
        self.interactor = interactor
        self.artistDetail = ArtistDetailEntity()
        self.artistImages = [ArtistImageEntity]()
        self.artistCredits = [MediaCreditEntity]()
    }
    
    func fetchArtist(artistId: Int) -> Void {
        interactor.fetchArtist(artistId) { artistData in
            self.artistDetail = artistData
        }
        interactor.fetchArtistImages(artistId) { images in
            self.artistImages = images
        }
        interactor.fetchArtistMovies(artistId) { movies in
            self.artistCredits.append(contentsOf: movies)
        }
        interactor.fetchArtistTV(artistId) { shows in
            self.artistCredits.append(contentsOf: shows)
        }
    }
    
}
