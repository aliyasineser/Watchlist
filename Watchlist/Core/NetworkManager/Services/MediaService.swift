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
}

final class MediaServiceStub: MediaService {

    func fetchMedia(request: NetworkRequest) async -> [Watchable] {
        var mediaList: [Watchable] = []
        for _ in 0..<9 {
            mediaList.append(Movie.mock)
        }
        return mediaList
    }

    func fetchMediaDetails(id: Int) async -> WatchableDetail? {
        MovieDetail.mock
    }

    func fetchMediaCredits(id: Int) async -> Credits? {
        Credits.mock
    }
}
