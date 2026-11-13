//
//  TVSerieDetailInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class TVSerieDetailInteractorMock: TVSerieDetailInteractor {
    var error: Error?
    var requestedPages: [Int] = []
    var getMediaDetailCallStub: Watchlist.WatchableDetail?
    var getMediaDetailCallCalledOnce: Bool = false

    func getMediaDetail(_ id: Int) async throws -> Watchlist.WatchableDetail? {
        if let error { throw error }
        getMediaDetailCallCalledOnce = true
        return getMediaDetailCallStub
    }
}
