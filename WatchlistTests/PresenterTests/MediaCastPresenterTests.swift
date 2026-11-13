//
//  MediaCastPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class MediaCastPresenterTests: XCTestCase {

    private var interactor: MediaCastInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MediaCastInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_LoadArtists() async throws {
        let sut = MediaCastDefaultPresenter(
            interactor,
            id: 1
        )

        interactor.fetchCastCallStub = [Cast.mock]

        await sut.loadArtists()

        let artists = sut.artists

        XCTAssertTrue(interactor.fetchCastCallCalledOnce)
        XCTAssertEqual(artists.count, 1)
        XCTAssertEqual(artists.first, Cast.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = MediaCastDefaultPresenter(interactor, id: 1)
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
        let sut = MediaCastDefaultPresenter(interactor, id: 1)
        interactor.error = CancellationError()
        await sut.loadArtists()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }
}
