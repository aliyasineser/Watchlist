//
//  MovieService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor MovieService: MediaService {
    private let requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func fetchMedia(request: NetworkRequest) async -> [Media] {
        do {
            let movies: MovieResponse = try await requestManager.initRequest(with: request)
            return movies.results.compactMap { WatchableToMediaMapper.convert(from: $0, type: .movie) }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchMediaDetails(id: Int) async -> MediaDetail? {
        let requestData = MovieRequest.getMovieDetail(id: id)
        do {
            let movie: MovieDetail = try await requestManager.initRequest(with: requestData)
            return WatchableToMediaMapper.convertDetail(from: movie, type: .movie)
        } catch {
            print(error.localizedDescription)
            return nil
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
