//
//  FavoritesPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation
import Observation

@MainActor
protocol FavoritesPresenter: AnyObject {
    var interactor: FavoritesInteractor { get }
    var artists: [ArtistDetail] { get }
    var movies: [Watchable] { get }
    var tvSeries: [Watchable] { get }

    func fetchFavorites() async
}

@MainActor
@Observable
class FavoritesDefaultPresenter: FavoritesPresenter {
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: FavoritesInteractor
    var artists: [ArtistDetail] = []
    var movies: [Watchable] = []
    var tvSeries: [Watchable] = []

    init(_ interactor: FavoritesInteractor) {
        self.interactor = interactor
    }

    func fetchFavorites() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let artists = try await interactor.getFavoriteArtists()
            let movies = try await interactor.getFavoriteMovies()
            let series = try await interactor.getFavoriteSeries()
            try Task.checkCancellation()
            self.artists = artists
            self.movies = movies
            self.tvSeries = series
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
