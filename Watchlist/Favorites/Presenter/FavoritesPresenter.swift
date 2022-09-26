//
//  FavoritesPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation
import Combine

class FavoritesPresenter: ObservableObject {
    private let interactor: FavoritesInteractor
    @Published var artists: [ArtistDetail] = []
    @Published var movies: [WatchableDetail] = []
    @Published var tvSeries: [WatchableDetail] = []

    init(_ interactor: FavoritesInteractor) {
        self.interactor = interactor
    }

    @MainActor func fetchFavorites() {
        Task {
            self.artists = await interactor.getFavoriteArtists()
            self.movies = await interactor.getFavoriteMovies()
            self.tvSeries = await interactor.getFavoriteSeries()
        }
    }
}
