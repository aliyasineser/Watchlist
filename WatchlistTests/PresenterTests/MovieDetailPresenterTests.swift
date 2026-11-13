//
//  MovieDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class MovieDetailPresenterTests: XCTestCase {

    private var interactor: MovieDetailInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MovieDetailInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_getMediaDetail() async throws {
        let sut = MovieDetailDefaultPresenter(
            interactor: interactor,
            id: 1,
            favoriteStorage: FavoriteStorageStub()
        )

        interactor.getMovieDetailCallStub = MovieDetail.mock

        await sut.getMediaDetail()

        let media = sut.media

        XCTAssertTrue(interactor.getMovieDetailCallCalledOnce)
        XCTAssertEqual(media, MovieDetail.mock)
        XCTAssertTrue(sut.hasLoaded)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = MovieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        interactor.error = NetworkError.invalidServerResponse
        await sut.getMediaDetail()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        interactor.getMovieDetailCallStub = MovieDetail.mock
        await sut.getMediaDetail()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = MovieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        interactor.error = CancellationError()
        await sut.getMediaDetail()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_missingPayloadDoesNotDisplayPreviewData() async {
        let sut = MovieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        await sut.getMediaDetail()
        XCTAssertFalse(sut.hasLoaded)
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_wrongPayloadDoesNotDisplayPreviewData() async {
        interactor.getMovieDetailCallStub = TvDetail.mock
        let sut = MovieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        await sut.getMediaDetail()
        XCTAssertFalse(sut.hasLoaded)
        XCTAssertNotNil(sut.fetchError)
    }
}
