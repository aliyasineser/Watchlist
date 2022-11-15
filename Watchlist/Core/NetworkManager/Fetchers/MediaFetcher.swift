//
//  MediaFetcher.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

class MediaFetcher: Fetchable {

    private var mediaList: [Watchable] = []
    private var pageCounter: Int = 0

    private var mediaStrategy: MediaListFetchStrategy
    private var mediaService: MediaService

    init(strategy: MediaListFetchStrategy, service: MediaService) {
        self.mediaStrategy = strategy
        self.mediaService = service
    }

    func fetchSinglePage() async throws -> [Watchable] {
        pageCounter += 1
        var watchables: [Watchable] = []
        watchables = try await mediaService.fetchMedia(request: mediaStrategy.fetch(page: pageCounter))
        return watchables
    }

    func fetchWithNextPage() async throws -> [Watchable] {
        let page = try await fetchSinglePage()
        self.mediaList.append(contentsOf: page)
        return self.mediaList
    }
}
