//
//  MovieReviewInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

protocol MediaReviewInteractor {
    func getMovieReview(_ id: Int, page: Int) async throws -> [Review]
    var mediaService: MediaService { get }
}

final class MediaReviewDefaultInteractor: MediaReviewInteractor {

    private(set) var mediaService: MediaService

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func getMovieReview(_ id: Int, page: Int) async throws -> [Review] {
        return try await mediaService.fetchReviews(id: id, page: page)
    }
}

final class MediaReviewInteractorStub: MediaReviewInteractor {
    let mediaService: MediaService = MovieService.shared
    func getMovieReview(_ id: Int, page: Int) async throws -> [Review] {
        return [
            Review.mock,
            Review.mock,
            Review.mock,
            Review.mock,
            Review.mock
        ]
    }
}
