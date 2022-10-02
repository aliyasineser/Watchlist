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

    func fetchMedia(request: NetworkRequest) async -> [Watchable] {
        do {
            let movies: MovieResponse = try await requestManager.initRequest(with: request)
            return movies.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchMediaDetails(id: Int) async -> WatchableDetail? {
        let requestData = MovieRequest.getMovieDetail(id: id)
        do {
            let movie: MovieDetail = try await requestManager.initRequest(with: requestData)
            return movie
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchReviews(id: Int, page: Int) async -> [Review] {
        let requestData = MovieRequest.getMovieReviews(id: id, page: page)
        do {
            let reviewResponse: MediaReviewResponse = try await requestManager.initRequest(with: requestData)
            return reviewResponse.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchMediaCredits(id: Int) async -> Credits? {
        let requestData = MovieRequest.getCredits(id: id)
        do {
            let credits: Credits = try await requestManager.initRequest(with: requestData)
            return credits
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
