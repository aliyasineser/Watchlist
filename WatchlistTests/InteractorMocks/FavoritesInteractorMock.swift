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

    var getFavoriteArtistsCallStub: [Watchlist.ArtistDetail] = []
    var getFavoriteArtistsCallCalledOnce: Bool = false

    func getFavoriteArtists() async -> [Watchlist.ArtistDetail] {
        return try! await withCheckedThrowingContinuation { continuation in
            getFavoriteArtistsCallCalledOnce = true
            continuation.resume(returning: getFavoriteArtistsCallStub)
        }
    }

    var getFavoriteMoviesCallStub: [Watchlist.Watchable] = []
    var getFavoriteMoviesCallCalledOnce: Bool = false

    func getFavoriteMovies() async -> [Watchlist.Watchable] {
        return try! await withCheckedThrowingContinuation { continuation in
            getFavoriteMoviesCallCalledOnce = true
            continuation.resume(returning: getFavoriteMoviesCallStub)
        }
    }

    var getFavoriteSeriesCallStub: [Watchlist.Watchable] = []
    var getFavoriteSeriesCallCalledOnce: Bool = false

    func getFavoriteSeries() async -> [Watchlist.Watchable] {
        return try! await withCheckedThrowingContinuation { continuation in
            getFavoriteSeriesCallCalledOnce = true
            continuation.resume(returning: getFavoriteSeriesCallStub)
        }
    }
}
