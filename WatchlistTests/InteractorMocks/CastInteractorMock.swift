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
    var error: Error?
    var requestedPages: [Int] = []

    var fetchCastCallStub: [Cast] = []
    var fetchCastCallCalledOnce: Bool = false

    func fetchCast(_ id: Int) async throws -> [Cast] {
        if let error { throw error }
        fetchCastCallCalledOnce = true
        return fetchCastCallStub
    }
}
