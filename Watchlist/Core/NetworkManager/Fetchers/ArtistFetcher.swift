//
//  ArtistFetcher.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.08.2022.
//

import Foundation

class ArtistFetcher {

    private var artists: [Artist] = []
    private var pageCounter: Int = 0
    private var hasMore = true

    private let artistService: ArtistService

    init(artistService: ArtistService = .shared) {
        self.artistService = artistService
    }

    func fetchSinglePage() async throws -> [Artist] {
        guard hasMore else { return [] }
        let nextPage = pageCounter + 1
        guard let artistsPage = try await artistService.fetchArtists(page: nextPage) else {
            throw NetworkError.invalidServerResponse
        }
        try Task.checkCancellation()
        pageCounter = nextPage
        hasMore = !(artistsPage.results ?? []).isEmpty
        return artistsPage.results ?? []
    }

    func fetchWithNextPage() async throws -> [Artist] {
        let artistsPage = try await fetchSinglePage()
        self.artists.append(contentsOf: artistsPage)
        return self.artists
    }
}
