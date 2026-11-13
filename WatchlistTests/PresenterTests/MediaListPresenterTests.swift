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

    func test_mostRecentMovies() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .mostRecentMovies
        )

        interactor.fetchNextMostRecentPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetchNextMostRecentPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_comingSoonMovies() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .comingSoonMovies
        )

        interactor.fetchNextUpcomingPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetchNextUpcomingPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_popularMovies() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .popularMovies
        )

        interactor.fetchNextPopularPageAsFullListStub = [Movie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetchNextPopularPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? Movie)
        XCTAssertEqual(media, Movie.mock)
    }

    func test_airingTodaySeries() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .airingTodaySeries
        )

        interactor.fetcthAiringTodayPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetcthAiringTodayPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_onTheAirSeries() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .onTheAirSeries
        )

        interactor.fetcthOnTheAirPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetcthOnTheAirPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_topRatedSeries() async throws {
        let sut = MediaListDefaultPresenter(
            interactor,
            section: .topRatedSeries
        )

        interactor.fetcthTopRatedPageAsFullListStub = [TVSerie.mock]

        await sut.fetchMedia()

        let mediaList = sut.mediaList

        XCTAssertTrue(interactor.fetcthTopRatedPageAsFullListWasCalledOnce)
        XCTAssertEqual(mediaList.count, 1)
        let media = try XCTUnwrap(mediaList.first as? TVSerie)
        XCTAssertEqual(media, TVSerie.mock)
    }

    func test_failureIsVisibleAndLoadingResets() async {
        let sut = MediaListDefaultPresenter(interactor, section: .popularMovies)
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
        let sut = MediaListDefaultPresenter(interactor, section: .popularMovies)
        interactor.error = CancellationError()
        await sut.fetchMedia()
        XCTAssertNil(sut.fetchError)
        XCTAssertFalse(sut.isLoading)
    }
}
