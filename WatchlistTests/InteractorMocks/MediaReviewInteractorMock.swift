//
//  MediaReviewInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class MediaReviewInteractorMock: MediaReviewInteractor {
    var error: Error?
    var requestedPages: [Int] = []

    var getMovieReviewCallStub: [Watchlist.Review] = []
    var getMovieReviewCallCalledOnce: Bool = false

    func getMovieReview(_ id: Int, page: Int) async throws -> [Watchlist.Review] {
        requestedPages.append(page)
        if let error { throw error }
        getMovieReviewCallCalledOnce = true
        return getMovieReviewCallStub
    }

    var mediaServiceStub: Watchlist.MediaService = MediaServiceMock()
    var mediaService: Watchlist.MediaService { mediaServiceStub }
}
