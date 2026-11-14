//
//  ArtistDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation
import Observation

@MainActor
protocol ArtistDetailPresenter: AnyObject {
    var interactor: ArtistDetailInteractor { get }
    var artistDetail: ArtistDetail? { get }
    var artistImages: [Profile] { get }
    var artistMovieCredits: [Cast] { get }
    var artistTVSerieCredits: [Cast] { get }
    var favoriteStorage: FavoriteStorage { get }

    func fetchArtist(artistId: Int) async
}

@MainActor
@Observable
class ArtistDetailDefaultPresenter: ArtistDetailPresenter {
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: ArtistDetailInteractor
    var artistDetail: ArtistDetail?
    var artistImages: [Profile]
    var artistMovieCredits: [Cast]
    var artistTVSerieCredits: [Cast]
    let favoriteStorage: FavoriteStorage

    init(interactor: ArtistDetailInteractor, favoriteStorage: FavoriteStorage? = nil) {
        self.favoriteStorage = favoriteStorage ?? FavoriteArtistStorage.shared
        self.interactor = interactor
        self.artistDetail = nil
        self.artistImages = [Profile]()
        self.artistMovieCredits = [Cast]()
        self.artistTVSerieCredits = [Cast]()
    }

    func fetchArtist(artistId: Int) async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let detail = try await interactor.fetchArtist(artistId)
            guard !Task.isCancelled else { return }
            let images = try await interactor.fetchArtistImages(artistId)
            guard !Task.isCancelled else { return }
            let movies = try await interactor.fetchArtistMovies(artistId)
            guard !Task.isCancelled else { return }
            let shows = try await interactor.fetchArtistTV(artistId)
            guard !Task.isCancelled else { return }
            artistDetail = detail
            artistImages = images
            artistMovieCredits = movies
            artistTVSerieCredits = shows
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
