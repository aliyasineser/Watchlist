//
//  TVSerieDetailPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
import Combine
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

    func test_getMediaDetail() throws {
        let sut = TVSerieDetailDefaultPresenter(
            interactor: interactor,
            id: 1
        )

        interactor.getMediaDetailCallStub = TvDetail.mock

        let mediaPublisher = sut.$media
            .dropFirst()
            .first()

        sut.getMediaDetail()

        let media = try awaitPublisher(mediaPublisher)

        XCTAssertTrue(interactor.getMediaDetailCallCalledOnce)
        XCTAssertEqual(media, TvDetail.mock)
    }
}
