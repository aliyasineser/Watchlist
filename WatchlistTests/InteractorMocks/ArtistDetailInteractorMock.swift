//
//  ArtistDetailInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 20.10.2022.
//
// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class ArtistDetailInteractorMock: ArtistDetailInteractor {

    var fetchArtistCallStub: ArtistDetail?
    var fetchArtistCallCalledOnce: Bool = false

    func fetchArtist(_ id: Int) async -> ArtistDetail? {
        fetchArtistCallCalledOnce = true
        return fetchArtistCallStub
    }

    var fetchArtistImagesCallStub: [Profile] = []
    var fetchArtistImagesCallCalledOnce: Bool = false

    func fetchArtistImages (_ id: Int) async -> [Profile] {
        fetchArtistImagesCallCalledOnce = true
        return fetchArtistImagesCallStub
    }

    var fetchArtistMoviesCallStub: [Cast] = []
    var fetchArtistMoviesCallCalledOnce: Bool = false

    func fetchArtistMovies(_ id: Int) async -> [Cast] {
        fetchArtistMoviesCallCalledOnce = true
        return fetchArtistMoviesCallStub
    }

    var fetchArtistTVCallStub: [Cast] = []
    var fetchArtistTVCallCalledOnce: Bool = false

    func fetchArtistTV(_ id: Int) async -> [Cast] {
        fetchArtistTVCallCalledOnce = true
        return fetchArtistTVCallStub
    }
}
