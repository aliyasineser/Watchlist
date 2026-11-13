//
//  FavoritesPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 22.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class FavoritesPresenterTests: XCTestCase {

    private var interactor: FavoritesInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = FavoritesInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_favoriteArtists() async throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteArtistsCallStub = [ArtistDetail.mock]

        await sut.fetchFavorites()

        let artists = sut.artists

        XCTAssertTrue(interactor.getFavoriteArtistsCallCalledOnce)
        XCTAssertEqual(artists.first, ArtistDetail.mock)
    }

    func test_favoriteMovies() async throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteMoviesCallStub = [Movie.mock]

        await sut.fetchFavorites()

        let movies = sut.movies

        XCTAssertTrue(interactor.getFavoriteMoviesCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(movies.first as? Movie)
        XCTAssertEqual(unwrappedMedia, Movie.mock)
    }

    func test_favoriteTVSeries() async throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteSeriesCallStub = [TVSerie.mock]

        await sut.fetchFavorites()

        let movies = sut.tvSeries

        XCTAssertTrue(interactor.getFavoriteSeriesCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(movies.first as? TVSerie)
        XCTAssertEqual(unwrappedMedia, TVSerie.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = FavoritesDefaultPresenter(interactor)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchFavorites()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        await sut.fetchFavorites()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = FavoritesDefaultPresenter(interactor)
        interactor.error = CancellationError()
        await sut.fetchFavorites()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }
}
