//
//  CastPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 11.10.2022.
//

import XCTest
import Combine
@testable import Watchlist

@MainActor
final class CastPresenterTests: XCTestCase {

    private var interactor: CastInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = CastInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_LoadArtists() throws {
        let sut = CastDefaultPresenter(
            interactor,
            id: 1
        )

        interactor.fetchCastCallStub = [Cast.mock]

        let castPublisher = sut.$casts
            .dropFirst()
            .first()

        sut.loadArtists()

        let casts = try awaitPublisher(castPublisher)

        XCTAssertTrue(interactor.fetchCastCallCalledOnce)
        XCTAssertEqual(casts.count, 1)
        XCTAssertEqual(casts.first, Cast.mock)
    }
}
