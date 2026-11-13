//
//  CastPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 11.10.2022.
//

import XCTest
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

    func test_LoadArtists() async throws {
        let sut = CastDefaultPresenter(
            interactor,
            id: 1
        )

        interactor.fetchCastCallStub = [Cast.mock]

        await sut.loadArtists()

        let casts = sut.casts

        XCTAssertTrue(interactor.fetchCastCallCalledOnce)
        XCTAssertEqual(casts.count, 1)
        XCTAssertEqual(casts.first, Cast.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = CastDefaultPresenter(interactor, id: 1)
        interactor.error = NetworkError.invalidServerResponse
        await sut.loadArtists()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        await sut.loadArtists()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = CastDefaultPresenter(interactor, id: 1)
        interactor.error = CancellationError()
        await sut.loadArtists()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }
}
