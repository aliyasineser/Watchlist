//
//  MovieDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
import Combine
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

    func test_getMediaDetail() throws {
        let sut = MovieDetailDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getMovieDetailCallStub = MovieDetail.mock

        let mediaPublisher = sut.$media
            .dropFirst()
            .first()

        sut.getMediaDetail()

        let media = try awaitPublisher(mediaPublisher)

        XCTAssertTrue(interactor.getMovieDetailCallCalledOnce)
        XCTAssertEqual(media, MovieDetail.mock)
    }
}
