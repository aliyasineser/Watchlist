//
//  MediaService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 21.09.2022.
//

import Foundation

protocol MediaService {
    func fetchMedia(request: NetworkRequest) async -> [Watchable]
    func fetchMediaDetails(id: Int) async -> MediaDetail?
    func fetchMediaCredits(id: Int) async -> Credits?
}

final class MediaServiceStub: MediaService {

    func fetchMedia(request: NetworkRequest) async -> [Watchable] {
        var mediaList: [Media] = []
        for _ in 0..<9 {
            mediaList.append(Media.mock)
        }
        return mediaList
    }

    func fetchMediaDetails(id: Int) async -> MediaDetail? {
        MediaDetail.mock
    }

    func fetchMediaCredits(id: Int) async -> Credits? {
        Credits.mock
    }
}
