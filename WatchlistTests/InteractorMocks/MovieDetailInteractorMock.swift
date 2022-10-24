//
//  MovieDetailInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class MovieDetailInteractorMock: MovieDetailInteractor {
    var getMovieDetailCallStub: Watchlist.WatchableDetail?
    var getMovieDetailCallCalledOnce: Bool = false

    func getMovieDetail(_ id: Int) async -> Watchlist.Watchable? {
        return try! await withCheckedThrowingContinuation { continuation in
            getMovieDetailCallCalledOnce = true
            continuation.resume(returning: getMovieDetailCallStub)
        }
    }
}
