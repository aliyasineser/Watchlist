//
//  CastInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 17.09.2022.
//
// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class CastInteractorMock: CastInteractor {

    var fetchCastCallStub: [Cast] = []
    var fetchCastCallCalledOnce: Bool = false

    func fetchCast(_ id: Int) async -> [Cast] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchCastCallCalledOnce = true
            continuation.resume(returning: fetchCastCallStub)
        }
    }
}
