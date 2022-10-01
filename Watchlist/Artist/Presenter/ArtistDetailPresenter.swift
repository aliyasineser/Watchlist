//
//  ArtistDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

@MainActor
protocol ArtistDetailPresenter: ObservableObject {
    var interactor: ArtistDetailInteractor { get }
    var artistDetail: ArtistDetail? { get }
    var artistImages: [Profile] { get }
    var artistMovieCredits: [Cast] { get }
    var artistTVSerieCredits: [Cast] { get }

    func fetchArtist(artistId: Int)
}

class ArtistDetailDefaultPresenter: ArtistDetailPresenter {
    private(set) var interactor: ArtistDetailInteractor
    @Published var artistDetail: ArtistDetail?
    @Published var artistImages: [Profile]
    @Published var artistMovieCredits: [Cast]
    @Published var artistTVSerieCredits: [Cast]

    init(interactor: ArtistDetailInteractor) {
        self.interactor = interactor
        self.artistDetail = nil
        self.artistImages = [Profile]()
        self.artistMovieCredits = [Cast]()
        self.artistTVSerieCredits = [Cast]()
    }

    func fetchArtist(artistId: Int) {
        Task {
            self.artistDetail = await interactor.fetchArtist(artistId)

            self.artistImages = await interactor.fetchArtistImages(artistId)

            let movies = await interactor.fetchArtistMovies(artistId)
            self.artistMovieCredits.append(contentsOf: movies)

            let shows = await interactor.fetchArtistTV(artistId)
            self.artistTVSerieCredits.append(contentsOf: shows)
        }
    }
}
