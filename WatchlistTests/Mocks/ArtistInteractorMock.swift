//
//  ArtistInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class ArtistInteractorMock: ArtistInteractor {

    var fetchArtistsCallStub: [Watchlist.Artist] = []
    var fetchArtistsCallCalledOnce: Bool = false

    func fetchArtists() async -> [Watchlist.Artist] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchArtistsCallCalledOnce = true
            continuation.resume(returning: fetchArtistsCallStub)
        }
    }
}
