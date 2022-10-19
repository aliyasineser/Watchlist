//
//  MediaListPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 12.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class MediaListPresenterTests: XCTestCase {

    private var interactor: MediaInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MediaInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_mostRecentMovies() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .mostRecentMovies
        )

        interactor.fetchNextMostRecentPageAsFullListStub = [Movie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchNextMostRecentPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_comingSoonMovies() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .comingSoonMovies
        )

        interactor.fetchNextUpcomingPageAsFullListStub = [Movie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchNextUpcomingPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_popularMovies() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .popularMovies
        )

        interactor.fetchNextPopularPageAsFullListStub = [Movie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetchNextPopularPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_airingTodaySeries() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .airingTodaySeries
        )

        interactor.fetcthAiringTodayPageAsFullListStub = [TVSerie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetcthAiringTodayPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_onTheAirSeries() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .onTheAirSeries
        )

        interactor.fetcthOnTheAirPageAsFullListStub = [TVSerie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetcthOnTheAirPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_topRatedSeries() throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .topRatedSeries
        )

        interactor.fetcthTopRatedPageAsFullListStub = [TVSerie.mock]

        let publisher = sut.$mediaList
            .dropFirst()
            .first()

        sut.fetchMedia()

        let mediaList = try awaitPublisher(publisher)

        XCTAssertTrue(interactor.fetcthTopRatedPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }
}
