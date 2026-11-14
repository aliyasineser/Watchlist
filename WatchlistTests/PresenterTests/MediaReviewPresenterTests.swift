//
//  MediaReviewPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class MediaReviewPresenterTests: XCTestCase {

    private var interactor: MediaReviewInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MediaReviewInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_fetchReviews() async throws {
        let sut = MediaReviewDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getMovieReviewCallStub = [Review.mock]

        await sut.fetchReviews()

        let reviews = sut.reviews

        XCTAssertTrue(interactor.getMovieReviewCallCalledOnce)
        XCTAssertEqual(reviews.first, Review.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = MediaReviewDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchReviews()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        interactor.getMovieReviewCallStub = [Review.mock]
        await sut.fetchReviews()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = MediaReviewDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = CancellationError()
        await sut.fetchReviews()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_failedPageIsRetriedBeforeAdvancing() async {
        let sut = MediaReviewDefaultPresenter(interactor: interactor, id: 1)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchReviews()
        interactor.error = nil
        interactor.getMovieReviewCallStub = [Review.mock]
        await sut.fetchReviews()
        await sut.fetchReviews()
        XCTAssertEqual(interactor.requestedPages, [1, 1, 2])
    }

    func test_emptyPageEndsPagination() async {
        let sut = MediaReviewDefaultPresenter(interactor: interactor, id: 1)
        await sut.fetchReviews()
        await sut.fetchReviews()
        XCTAssertFalse(sut.hasMore)
        XCTAssertEqual(interactor.requestedPages, [1])
    }
}
