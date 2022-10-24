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

    var fetchMediaCallStub: [Watchlist.Watchable] = []
    var fetchMediaCallCalledOnce: Bool = false

    func fetchMedia(request: Watchlist.NetworkRequest) async -> [Watchlist.Watchable] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchMediaCallCalledOnce = true
            continuation.resume(returning: fetchMediaCallStub)
        }
    }

    var fetchMediaDetailsCallStub: Watchlist.WatchableDetail?
    var fetchMediaDetailsCallCalledOnce: Bool = false

    func fetchMediaDetails(id: Int) async -> Watchlist.WatchableDetail? {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchMediaDetailsCallCalledOnce = true
            continuation.resume(returning: fetchMediaDetailsCallStub)
        }
    }

    var fetchMediaCreditsCallStub: Watchlist.Credits?
    var fetchMediaCreditsCallCalledOnce: Bool = false

    func fetchMediaCredits(id: Int) async -> Watchlist.Credits? {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchMediaCreditsCallCalledOnce = true
            continuation.resume(returning: fetchMediaCreditsCallStub)
        }
    }

    var fetchReviewsCallStub: [Watchlist.Review] = []
    var fetchReviewsCallCalledOnce: Bool = false

    func fetchReviews(id: Int, page: Int) async -> [Watchlist.Review] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchReviewsCallCalledOnce = true
            continuation.resume(returning: fetchReviewsCallStub)
        }
    }

    var fetchSimilarCallStub: [Watchlist.Watchable] = []
    var fetchSimilarCallCalledOnce: Bool = false

    func fetchSimilar(id: Int, page: Int) async -> [Watchlist.Watchable] {
        return try! await withCheckedThrowingContinuation { continuation in
            fetchSimilarCallCalledOnce = true
            continuation.resume(returning: fetchSimilarCallStub)
        }
    }
}
