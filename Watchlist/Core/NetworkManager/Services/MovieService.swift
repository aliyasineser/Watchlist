//
//  MovieService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor MovieService {
    private let requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func fetchMovies(request: NetworkRequest) async -> [Movie] {
        do {
            let movies: MovieResponse = try await
            requestManager.initRequest(with: request)
            return movies.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchMovieDetail(id: Int) async -> MediaDetail? {
        let requestData = MovieRequest.getMovieDetail(id: id)
        do {
            let movie: MovieDetail = try await requestManager.initRequest(with: requestData)
            return WatchableToMediaMapper.convertDetail(from: movie, type: .movie)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchMovieCredits(id: Int) async -> Credits? {
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
