//
//  MediaSimilarInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

protocol MediaSimilarInteractor {
    func getSimilarMedia(_ id: Int, page: Int) async -> [Watchable]
    var mediaService: MediaService { get }
}

final class MediaSimilarDefaultInteractor: MediaSimilarInteractor {

    private(set) var mediaService: MediaService

    init(mediaService: MediaService) {
        self.mediaService = mediaService
    }

    func getSimilarMedia(_ id: Int, page: Int) async -> [Watchable] {
        return await mediaService.fetchSimilar(id: id, page: page)
    }
}

final class MediaSimilarInteractorStub: MediaSimilarInteractor {
    let mediaService: MediaService = MovieService.shared
    func getSimilarMedia(_ id: Int, page: Int) async -> [Watchable] {
        return [
            Movie.mock,
            Movie.mock,
            Movie.mock,
            Movie.mock,
            Movie.mock
        ]
    }
}
