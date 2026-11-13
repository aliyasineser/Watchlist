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
    var error: Error?
    var requestedPages: [Int] = []
    var fetchCastCallStub: [Watchlist.Cast] = []
    var fetchCastCallCalledOnce: Bool = false

    func fetchCast(_ id: Int) async throws -> [Watchlist.Cast] {
        if let error { throw error }
        fetchCastCallCalledOnce = true
        return fetchCastCallStub
    }
}
