//
//  MediaCastInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class MediaCastInteractorMock: MediaCastInteractor {
    var fetchCastCallStub: [Watchlist.Cast] = []
    var fetchCastCallCalledOnce: Bool = false

    func fetchCast(_ id: Int) async -> [Watchlist.Cast] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchCastCallCalledOnce = true
            continuation.resume(returning: fetchCastCallStub)
        }
    }
}
