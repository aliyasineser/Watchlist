//
//  ArtistDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 22.10.2022.
//

import XCTest
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

    func test_artistDetail() async throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor, favoriteStorage: FavoriteStorageStub())

        interactor.fetchArtistCallStub = ArtistDetail.mock

        await sut.fetchArtist(artistId: 1)

        let detail = sut.artistDetail

        XCTAssertTrue(interactor.fetchArtistCallCalledOnce)
        XCTAssertEqual(detail, ArtistDetail.mock)
    }

    func test_artistImages() async throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor, favoriteStorage: FavoriteStorageStub())

        interactor.fetchArtistImagesCallStub = [Profile.mock]

        await sut.fetchArtist(artistId: 1)

        let images = sut.artistImages

        XCTAssertTrue(interactor.fetchArtistImagesCallCalledOnce)
        XCTAssertEqual(images.first, Profile.mock)
    }

    func test_artistMovieCredits() async throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor, favoriteStorage: FavoriteStorageStub())

        interactor.fetchArtistMoviesCallStub = [Cast.mock]

        await sut.fetchArtist(artistId: 1)

        let images = sut.artistMovieCredits

        XCTAssertTrue(interactor.fetchArtistMoviesCallCalledOnce)
        XCTAssertEqual(images.first, Cast.mock)
    }

    func test_artistTVSerieCredits() async throws {
        let sut = ArtistDetailDefaultPresenter(interactor: interactor, favoriteStorage: FavoriteStorageStub())

        interactor.fetchArtistTVCallStub = [Cast.mock]

        await sut.fetchArtist(artistId: 1)

        let images = sut.artistTVSerieCredits

        XCTAssertTrue(interactor.fetchArtistTVCallCalledOnce)
        XCTAssertEqual(images.first, Cast.mock)
    }

    func test_reloadingDoesNotDuplicateCredits() async {
        interactor.fetchArtistMoviesCallStub = [Cast.mock]
        interactor.fetchArtistTVCallStub = [Cast.mock]
        let sut = ArtistDetailDefaultPresenter(interactor: interactor, favoriteStorage: FavoriteStorageStub())
        await sut.fetchArtist(artistId: 1)
        await sut.fetchArtist(artistId: 1)
        XCTAssertEqual(sut.artistMovieCredits.count, 1)
        XCTAssertEqual(sut.artistTVSerieCredits.count, 1)
        XCTAssertFalse(sut.isLoading)
    }
}
