//
//  FavoritesInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 22.10.2022.
//
// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class FavoritesInteractorMock: FavoritesInteractor {
    var error: Error?
    var requestedPages: [Int] = []

    var getFavoriteArtistsCallStub: [Watchlist.ArtistDetail] = []
    var getFavoriteArtistsCallCalledOnce: Bool = false

    func getFavoriteArtists() async throws -> [Watchlist.ArtistDetail] {
        if let error { throw error }
        getFavoriteArtistsCallCalledOnce = true
        return getFavoriteArtistsCallStub
    }

    var getFavoriteMoviesCallStub: [Watchlist.Watchable] = []
    var getFavoriteMoviesCallCalledOnce: Bool = false

    func getFavoriteMovies() async throws -> [Watchlist.Watchable] {
        if let error { throw error }
        getFavoriteMoviesCallCalledOnce = true
        return getFavoriteMoviesCallStub
    }

    var getFavoriteSeriesCallStub: [Watchlist.Watchable] = []
    var getFavoriteSeriesCallCalledOnce: Bool = false

    func getFavoriteSeries() async throws -> [Watchlist.Watchable] {
        if let error { throw error }
        getFavoriteSeriesCallCalledOnce = true
        return getFavoriteSeriesCallStub
    }
}
