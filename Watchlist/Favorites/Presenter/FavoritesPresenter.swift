//
//  FavoritesPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation
import Combine

@MainActor
protocol FavoritesPresenter: ObservableObject {
    var interactor: FavoritesInteractor { get }
    var artists: [ArtistDetail] { get }
    var movies: [Watchable] { get }
    var tvSeries: [Watchable] { get }

    func fetchFavorites()
}

class FavoritesDefaultPresenter: FavoritesPresenter {
    private(set) var interactor: FavoritesInteractor
    @Published var artists: [ArtistDetail] = []
    @Published var movies: [Watchable] = []
    @Published var tvSeries: [Watchable] = []

    init(_ interactor: FavoritesInteractor) {
        self.interactor = interactor
    }

    func fetchFavorites() {
        Task {
            self.artists = await interactor.getFavoriteArtists()
            self.movies = await interactor.getFavoriteMovies()
            self.tvSeries = await interactor.getFavoriteSeries()
        }
    }
}
