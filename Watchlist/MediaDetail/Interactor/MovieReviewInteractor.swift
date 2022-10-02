//
//  MovieReviewInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

protocol MovieReviewInteractor {
    func getMovieReview(_ id: Int, page: Int) async -> [Review]
    var mediaService: MediaService { get }
}

final class MovieReviewDefaultInteractor: MovieReviewInteractor {

    private(set) var mediaService: MediaService

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func getMovieReview(_ id: Int, page: Int) async -> [Review] {
        return await mediaService.fetchReviews(id: id, page: page)
    }
}

final class MovieReviewInteractorStub: MovieReviewInteractor {
    let mediaService: MediaService = MovieService.shared
    func getMovieReview(_ id: Int, page: Int) async -> [Review] {
        return [
            Review.mock,
            Review.mock,
            Review.mock,
            Review.mock,
            Review.mock
        ]
    }
}
