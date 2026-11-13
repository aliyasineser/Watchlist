//
//  SimilarMediaPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 19.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class SimilarMediaPresenterTests: XCTestCase {

    private var interactor: MediaSimilarInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MediaSimilarInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_fetchSimilar() async throws {
        let sut = MediaSimilarDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getSimilarMediaCallStub = [Movie.mock]

        await sut.fetchSimilar()

        let reviews = sut.media

        XCTAssertTrue(interactor.getSimilarMediaCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(reviews.first as? Movie)
        XCTAssertEqual(unwrappedMedia, Movie.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = MediaSimilarDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchSimilar()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        interactor.getSimilarMediaCallStub = [Movie.mock]
        await sut.fetchSimilar()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = MediaSimilarDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = CancellationError()
        await sut.fetchSimilar()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_failedPageIsRetriedBeforeAdvancing() async {
        let sut = MediaSimilarDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchSimilar()
        interactor.error = nil
        interactor.getSimilarMediaCallStub = [Movie.mock]
        await sut.fetchSimilar()
        await sut.fetchSimilar()
        XCTAssertEqual(interactor.requestedPages, [1, 1, 2])
    }

    func test_emptyPageEndsPagination() async {
        let sut = MediaSimilarDefaultPresenter(interactor: interactor, id: 1)
        await sut.fetchSimilar()
        await sut.fetchSimilar()
        XCTAssertFalse(sut.hasMore)
        XCTAssertEqual(interactor.requestedPages, [1])
    }
}
