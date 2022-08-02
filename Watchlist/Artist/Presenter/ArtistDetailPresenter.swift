//
//  ArtistDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

@MainActor
class ArtistDetailPresenter: ObservableObject {
    var interactor: ArtistDetailInteractor
    @Published var artistDetail: ArtistDetailEntity?
    @Published var artistImages: [ArtistImageEntity]
    @Published var artistCredits: [MediaCreditEntity]
    
    init(interactor: ArtistDetailInteractor) {
        self.interactor = interactor
        self.artistDetail = nil
        self.artistImages = [ArtistImageEntity]()
        self.artistCredits = [MediaCreditEntity]()
    }
    
    func fetchArtist(artistId: Int) -> Void {
        Task {
            self.artistDetail = await interactor.fetchArtist(artistId)
            
            self.artistImages = await interactor.fetchArtistImages(artistId)
            
            let movies = await interactor.fetchArtistMovies(artistId)
            self.artistCredits.append(contentsOf: movies)
            
            let shows = await interactor.fetchArtistTV(artistId)
            self.artistCredits.append(contentsOf: shows)
        }
    }
    
}
