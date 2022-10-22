//
//  ArtistDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 22.10.2022.
//

import XCTest
import Combine
@testable import Watchlist

@MainActor
final class ArtistDetailPresenterTests: XCTestCase {

    private var interactor: ArtistDetailInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = ArtistDetailInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_artistDetail() throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor)

        interactor.fetchArtistCallStub = ArtistDetail.mock

        let publisher = sut.$artistDetail
            .dropFirst()
            .first()

        sut.fetchArtist(artistId: 1)

        let detail = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchArtistCallCalledOnce)
        XCTAssertEqual(detail, ArtistDetail.mock)
    }

    func test_artistImages() throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor)

        interactor.fetchArtistImagesCallStub = [Profile.mock]

        let publisher = sut.$artistImages
            .dropFirst()
            .first()

        sut.fetchArtist(artistId: 1)

        let images = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchArtistImagesCallCalledOnce)
        XCTAssertEqual(images.first, Profile.mock)
    }

    func test_artistMovieCredits() throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor)

        interactor.fetchArtistMoviesCallStub = [Cast.mock]

        let publisher = sut.$artistMovieCredits
            .dropFirst()
            .first()

        sut.fetchArtist(artistId: 1)

        let images = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchArtistMoviesCallCalledOnce)
        XCTAssertEqual(images.first, Cast.mock)
    }

    func test_artistTVSerieCredits() throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor)

        interactor.fetchArtistTVCallStub = [Cast.mock]

        let publisher = sut.$artistTVSerieCredits
            .dropFirst()
            .first()

        sut.fetchArtist(artistId: 1)

        let images = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchArtistTVCallCalledOnce)
        XCTAssertEqual(images.first, Cast.mock)
    }
}
