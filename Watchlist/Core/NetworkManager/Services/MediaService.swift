//
//  MediaService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 21.09.2022.
//

import Foundation

protocol MediaService {
    func fetchMedia(request: NetworkRequest) async -> [Watchable]
    func fetchMediaDetails(id: Int) async -> WatchableDetail?
    func fetchMediaCredits(id: Int) async -> Credits?
    func fetchReviews(id: Int, page: Int) async -> [Review]
}

final class MediaServiceStub: MediaService {

    func fetchMedia(request: NetworkRequest) async -> [Watchable] {
        var mediaList: [Watchable] = []
        for _ in 0..<9 {
            mediaList.append(Movie.mock)
        }
        return mediaList
    }

    func fetchReviews(id: Int, page: Int) async -> [Review] {
        [Review.mock, Review.mock]
    }

    func fetchMediaDetails(id: Int) async -> WatchableDetail? {
        MovieDetail.mock
    }

    func fetchMediaCredits(id: Int) async -> Credits? {
        Credits.mock
    }
}
