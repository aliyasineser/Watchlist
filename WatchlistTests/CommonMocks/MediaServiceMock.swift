//
//  MediaServiceMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class MediaServiceMock: MediaService {
    var error: Error?
    var requestedPages: [Int] = []

    var fetchMediaCallStub: [Watchlist.Watchable] = []
    var fetchMediaCallCalledOnce: Bool = false

    func fetchMedia(request: Watchlist.NetworkRequest) async throws -> [Watchlist.Watchable] {
        if let error { throw error }
        fetchMediaCallCalledOnce = true
        return fetchMediaCallStub
    }

    var fetchMediaDetailsCallStub: Watchlist.WatchableDetail?
    var fetchMediaDetailsCallCalledOnce: Bool = false

    func fetchMediaDetails(id: Int) async throws -> Watchlist.WatchableDetail? {
        if let error { throw error }
        fetchMediaDetailsCallCalledOnce = true
        return fetchMediaDetailsCallStub
    }

    var fetchMediaCreditsCallStub: Watchlist.Credits?
    var fetchMediaCreditsCallCalledOnce: Bool = false

    func fetchMediaCredits(id: Int) async throws -> Watchlist.Credits? {
        if let error { throw error }
        fetchMediaCreditsCallCalledOnce = true
        return fetchMediaCreditsCallStub
    }

    var fetchReviewsCallStub: [Watchlist.Review] = []
    var fetchReviewsCallCalledOnce: Bool = false

    func fetchReviews(id: Int, page: Int) async throws -> [Watchlist.Review] {
        requestedPages.append(page)
        if let error { throw error }
        fetchReviewsCallCalledOnce = true
        return fetchReviewsCallStub
    }

    var fetchSimilarCallStub: [Watchlist.Watchable] = []
    var fetchSimilarCallCalledOnce: Bool = false

    func fetchSimilar(id: Int, page: Int) async throws -> [Watchlist.Watchable] {
        requestedPages.append(page)
        if let error { throw error }
        fetchSimilarCallCalledOnce = true
        return fetchSimilarCallStub
    }
}
