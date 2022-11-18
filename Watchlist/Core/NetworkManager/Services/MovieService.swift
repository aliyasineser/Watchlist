//
//  MovieService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

final class MovieService: MediaService {
    private let requestManager: RequestManager

    public static let shared = MovieService()

    init(requestManager: RequestManager = DefaultRequestManager()) {
        self.requestManager = requestManager
    }

    func fetchMedia(request: NetworkRequest) async throws -> [Watchable] {
        let movies: MovieResponse = try await requestManager.initRequest(with: request)
        return movies.results
    }

    func fetchMediaDetails(id: Int) async throws -> WatchableDetail? {
        let requestData = MovieRequest.getMovieDetail(id: id)
        let movie: MovieDetail = try await requestManager.initRequest(with: requestData)
        return movie

    }

    func fetchReviews(id: Int, page: Int) async throws -> [Review] {
        let requestData = MovieRequest.getMovieReviews(id: id, page: page)
        let reviewResponse: MediaReviewResponse = try await requestManager.initRequest(with: requestData)
        return reviewResponse.results

    }

    func fetchSimilar(id: Int, page: Int) async throws -> [Watchable] {
        let requestData = MovieRequest.getSimilarMoviesTo(id: id, page: page)
        let response: MovieSimilarResponse = try await requestManager.initRequest(with: requestData)
        return response.results
    }

    func fetchMediaCredits(id: Int) async throws -> Credits? {
        let requestData = MovieRequest.getCredits(id: id)
        let credits: Credits = try await requestManager.initRequest(with: requestData)
        return credits
    }
}
