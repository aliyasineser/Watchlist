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

    func test_favoriteArtists() throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteArtistsCallStub = [ArtistDetail.mock]

        let publisher = sut.$artists
            .dropFirst()
            .first()

        sut.fetchFavorites()

        let artists = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.getFavoriteArtistsCallCalledOnce)
        XCTAssertEqual(artists.first, ArtistDetail.mock)
    }

    func test_favoriteMovies() throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteMoviesCallStub = [Movie.mock]

        let publisher = sut.$movies
            .dropFirst()
            .first()

        sut.fetchFavorites()

        let movies = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.getFavoriteMoviesCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(movies.first as? Movie)
        XCTAssertEqual(unwrappedMedia, Movie.mock)
    }

    func test_favoriteTVSeries() throws {
        let sut = FavoritesDefaultPresenter(interactor)

        interactor.getFavoriteSeriesCallStub = [TVSerie.mock]

        let publisher = sut.$tvSeries
            .dropFirst()
            .first()

        sut.fetchFavorites()

        let movies = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.getFavoriteSeriesCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(movies.first as? TVSerie)
        XCTAssertEqual(unwrappedMedia, TVSerie.mock)
    }
}
