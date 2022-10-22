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
        return try! await withCheckedThrowingContinuation { continuation in
            fetchArtistCallCalledOnce = true
            continuation.resume(returning: fetchArtistCallStub)
        }
    }

    var fetchArtistImagesCallStub: [Profile] = []
    var fetchArtistImagesCallCalledOnce: Bool = false

    func fetchArtistImages (_ id: Int) async -> [Profile] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchArtistImagesCallCalledOnce = true
            continuation.resume(returning: fetchArtistImagesCallStub)
        }
    }

    var fetchArtistMoviesCallStub: [Cast] = []
    var fetchArtistMoviesCallCalledOnce: Bool = false

    func fetchArtistMovies(_ id: Int) async -> [Cast] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchArtistMoviesCallCalledOnce = true
            continuation.resume(returning: fetchArtistMoviesCallStub)
        }
    }

    var fetchArtistTVCallStub: [Cast] = []
    var fetchArtistTVCallCalledOnce: Bool = false

    func fetchArtistTV(_ id: Int) async -> [Cast] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchArtistTVCallCalledOnce = true
            continuation.resume(returning: fetchArtistTVCallStub)
        }
    }
}
