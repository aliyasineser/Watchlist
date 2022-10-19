//
//  MediaReviewPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
import Combine
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

    func test_fetchReviews() throws {
        let sut = MediaReviewDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getMovieReviewCallStub = [Review.mock]

        let publisher = sut.$reviews
            .dropFirst()
            .first()

        sut.fetchReviews()

        let reviews = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.getMovieReviewCallCalledOnce)
        XCTAssertEqual(reviews.first, Review.mock)
    }
}
