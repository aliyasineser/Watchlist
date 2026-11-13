//
//  TVSerieDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class TVSerieDetailPresenterTests: XCTestCase {

    private var interactor: TVSerieDetailInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = TVSerieDetailInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_getMediaDetail() async throws {
        let sut = TVSerieDetailDefaultPresenter(
            interactor: interactor,
            id: 1,
            favoriteStorage: FavoriteStorageStub()
        )

        interactor.getMediaDetailCallStub = TvDetail.mock

        await sut.getMediaDetail()

        let media = sut.media

        XCTAssertTrue(interactor.getMediaDetailCallCalledOnce)
        XCTAssertEqual(media, TvDetail.mock)
        XCTAssertTrue(sut.hasLoaded)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = TVSerieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        interactor.error = NetworkError.invalidServerResponse
        await sut.getMediaDetail()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        interactor.getMediaDetailCallStub = TvDetail.mock
        await sut.getMediaDetail()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = TVSerieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        interactor.error = CancellationError()
        await sut.getMediaDetail()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_missingPayloadDoesNotDisplayPreviewData() async {
        let sut = TVSerieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        await sut.getMediaDetail()
        XCTAssertFalse(sut.hasLoaded)
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_wrongPayloadDoesNotDisplayPreviewData() async {
        interactor.getMediaDetailCallStub = MovieDetail.mock
        let sut = TVSerieDetailDefaultPresenter(interactor: interactor, id: 1, favoriteStorage: FavoriteStorageStub())
        await sut.getMediaDetail()
        XCTAssertFalse(sut.hasLoaded)
        XCTAssertNotNil(sut.fetchError)
    }
}
