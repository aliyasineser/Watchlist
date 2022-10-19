//
//  MediaCastPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
import Combine
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

    func test_LoadArtists() throws {
        let sut = MediaCastDefaultPresenter(
            interactor,
            id: 1
        )

        interactor.fetchCastCallStub = [Cast.mock]

        let castPublisher = sut.$artists
            .dropFirst()
            .first()

        sut.loadArtists()

        let artists = try awaitPublisher(castPublisher)

        XCTAssertTrue(interactor.fetchCastCallCalledOnce)
        XCTAssertEqual(artists.count, 1)
        XCTAssertEqual(artists.first, Cast.mock)
    }
}
