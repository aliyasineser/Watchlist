//
//  DiscoverPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 12.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class DiscoverPresenterTests: XCTestCase {

    private var interactor: MediaInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = MediaInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_mostRecentMovies() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetchNextMostRecentPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mostRecentMovies

        XCTAssertTrue(interactor.fetchNextMostRecentPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_comingSoonMovies() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetchNextUpcomingPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.upcomingMovies

        XCTAssertTrue(interactor.fetchNextUpcomingPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_popularMovies() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetchNextPopularPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.popularMovies

        XCTAssertTrue(interactor.fetchNextPopularPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_airingTodaySeries() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetcthAiringTodayPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.airingTodaySeries

        XCTAssertTrue(interactor.fetcthAiringTodayPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_onTheAirSeries() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetcthOnTheAirPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.onTheAirSeries

        XCTAssertTrue(interactor.fetcthOnTheAirPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_topRatedSeries() async throws {
        let sut = DiscoverDefaultPresenter(
            interactor
        )

        interactor.fetcthTopRatedPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.topRatedSeries

        XCTAssertTrue(interactor.fetcthTopRatedPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }


    func test_failureIsVisibleAndLoadingResets() async {
        let sut = DiscoverDefaultPresenter(interactor)
        interactor.error = NetworkError.invalidServerResponse
        await sut.fetchMedia()
        XCTAssertNotNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)

        interactor.error = nil
        await sut.fetchMedia()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cancellationDoesNotShowAlert() async {
        let sut = DiscoverDefaultPresenter(interactor)
        interactor.error = CancellationError()
        await sut.fetchMedia()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }

    func test_cumulativeResultsReplaceExistingSections() async {
        interactor.fetchNextPopularPageAsFullListStub = [Movie.mock]
        let sut = DiscoverDefaultPresenter(interactor)
        await sut.fetchMedia()
        await sut.fetchMedia()
        XCTAssertEqual(sut.popularMovies.count, 1)
        XCTAssertFalse(sut.isLoading)
    }
}
