//
//  ArtistPresenterTests.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

import XCTest
@testable import Watchlist

@MainActor
final class ArtistPresenterTests: XCTestCase {

    private var interactor: ArtistInteractorMock!

    override func setUp() {
        super.setUp()
        self.interactor = ArtistInteractorMock()
    }

    override func tearDown() {
        self.interactor = nil
        super.tearDown()
    }

    func test_LoadArtists() async throws {
        let sut = ArtistDefaultPresenter(
            interactor
        )

        interactor.fetchArtistsCallStub = [Artist.mock]

        await sut.loadArtists()

        let artists = sut.artists

        XCTAssertTrue(interactor.fetchArtistsCallCalledOnce)
        XCTAssertEqual(artists.count, 1)
        XCTAssertEqual(artists.first, Artist.mock)
    }
}

extension ArtistPresenterTests {
    func test_overlappingLoadsAreIgnoredAndCancellationDoesNotPublish() async {
        let started = expectation(description: "Fetch started")
        let suspended = SuspendedArtistInteractor { started.fulfill() }
        let sut = ArtistDefaultPresenter(suspended)
        let load = Task { await sut.loadArtists() }
        await fulfillment(of: [started], timeout: 1)
        XCTAssertTrue(sut.isLoading)

        await sut.loadArtists()
        XCTAssertEqual(suspended.calls, 1)
        load.cancel()
        suspended.continuation?.resume(returning: [Artist.mock])
        await load.value
        XCTAssertTrue(sut.artists.isEmpty)
        XCTAssertFalse(sut.isLoading)
    }
}

private final class SuspendedArtistInteractor: ArtistInteractor {
    var calls = 0
    var continuation: CheckedContinuation<[Artist], Never>?
    let didStart: () -> Void

    init(didStart: @escaping () -> Void) {
        self.didStart = didStart
    }

    func fetchArtists() async -> [Artist] {
        calls += 1
        return await withCheckedContinuation { continuation in
            self.continuation = continuation
            didStart()
        }
    }
}
