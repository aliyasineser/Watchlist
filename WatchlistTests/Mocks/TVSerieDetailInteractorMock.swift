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
    var getMediaDetailCallStub: Watchlist.WatchableDetail?
    var getMediaDetailCallCalledOnce: Bool = false

    func getMediaDetail(_ id: Int) async -> Watchlist.WatchableDetail? {
        return try! await withCheckedThrowingContinuation { continuation in
            getMediaDetailCallCalledOnce = true
            continuation.resume(returning: getMediaDetailCallStub)
        }
    }
}
