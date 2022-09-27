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
    @Published var artistDetail: ArtistDetail?
    @Published var artistImages: [Profile]
    @Published var artistCredits: [Cast]

    init(interactor: ArtistDetailInteractor) {
        self.interactor = interactor
        self.artistDetail = nil
        self.artistImages = [Profile]()
        self.artistCredits = [Cast]()
    }

    func fetchArtist(artistId: Int) {
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
