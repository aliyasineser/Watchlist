//
//  MediaService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 21.09.2022.
//

import Foundation

protocol MediaService {
    func fetchMedia(request: NetworkRequest) async throws -> [Watchable]
    func fetchMediaDetails(id: Int) async throws -> WatchableDetail?
    func fetchMediaCredits(id: Int) async throws -> Credits?
    func fetchReviews(id: Int, page: Int) async throws -> [Review]
    func fetchSimilar(id: Int, page: Int) async throws -> [Watchable]
}

final class MediaServiceStub: MediaService {
    func fetchSimilar(id: Int, page: Int) async throws -> [Watchable] {
        [
            Movie.mock,
            Movie.mock,
            Movie.mock,
            Movie.mock,
            Movie.mock
        ]
    }

    func fetchMedia(request: NetworkRequest) async throws -> [Watchable] {
        var mediaList: [Watchable] = []
        for _ in 0..<9 {
            mediaList.append(Movie.mock)
        }
        return mediaList
    }

    func fetchReviews(id: Int, page: Int) async throws -> [Review] {
        [Review.mock, Review.mock]
    }

    func fetchMediaDetails(id: Int) async throws -> WatchableDetail? {
        MovieDetail.mock
    }

    func fetchMediaCredits(id: Int) async throws -> Credits? {
        Credits.mock
    }
}
