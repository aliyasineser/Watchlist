//
//  ArtistPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class ArtistPresenterTests: XCTestCase {

    private var interactor: ArtistInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = ArtistInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_LoadArtists() throws {
        let sut = ArtistDefaultPresenter(
            interactor
        )

        interactor.fetchArtistsCallStub = [Artist.mock]

        let castPublisher = sut.$artists
            .dropFirst()
            .first()

        sut.loadArtists()

        let artists = try awaitPublisher(castPublisher)

        XCTAssertTrue(interactor.fetchArtistsCallCalledOnce)
        XCTAssertEqual(artists.count, 1)
        XCTAssertEqual(artists.first, Artist.mock)
    }
}
