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
    
    init(interactor: ArtistDetailInteractor) {
        self.interactor = interactor
        self.artistDetail = ArtistDetailEntity()
    }
    
    func fetchArtist(artistId: Int) -> Void {
        interactor.fetchArtist(artistId) { artistData in
            self.artistDetail = artistData
        }
    }
    
}
