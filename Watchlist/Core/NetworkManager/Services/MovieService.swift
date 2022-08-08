//
//  MovieService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor MovieService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func fetchPopularMovies(page: Int) async -> [Movie] {
        let requestData = MovieRequest.getPopularMovies(page: page)
        do {
            let popularMovies: MovieResponse = try await requestManager.initRequest(with: requestData)
            return popularMovies.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchUpcomingMovies(page: Int) async -> [Movie] {
        let requestData = MovieRequest.getUpcomingMovies(page: page)
        do {
            let popularMovies: MovieResponse = try await requestManager.initRequest(with: requestData)
            return popularMovies.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchNowPlayingMovies(page: Int) async -> [Movie] {
        let requestData = MovieRequest.getNowPlayingMovies(page: page)
        do {
            let popularMovies: MovieResponse = try await requestManager.initRequest(with: requestData)
            return popularMovies.results
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
