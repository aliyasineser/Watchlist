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
        let nextPage = pageCounter + 1
        let watchables = try await mediaService.fetchMedia(request: mediaStrategy.fetch(page: nextPage))
        try Task.checkCancellation()
        pageCounter = nextPage
        return watchables
    }

    func fetchWithNextPage() async throws -> [Watchable] {
        let page = try await fetchSinglePage()
        var identifiers = Set(mediaList.map(\.id))
        mediaList.append(contentsOf: page.filter { identifiers.insert($0.id).inserted })
        return self.mediaList
    }
}
