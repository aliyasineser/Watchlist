//
//  CastInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 17.09.2022.
//

import Foundation
@testable import Watchlist

final class CastInteractorMock: CastInteractor {

    var fetchCastCallStub: [Cast] = []
    var fetchCastCallCalledOnce: Bool = false

    func fetchCast(_ id: Int) async -> [Cast] {
        fetchCastCallCalledOnce = true
        return fetchCastCallStub
    }
}
