//
//  SimilarMediaPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 19.10.2022.
//

import XCTest
import Combine
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

    func test_fetchSimilar() throws {
        let sut = MediaSimilarDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getSimilarMediaCallStub = [Movie.mock]

        let publisher = sut.$media
            .dropFirst()
            .first()

        sut.fetchSimilar()

        let reviews = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.getSimilarMediaCallCalledOnce)
        let unwrappedMedia = try XCTUnwrap(reviews.first as? Movie)
        XCTAssertEqual(unwrappedMedia, Movie.mock)
    }
}
