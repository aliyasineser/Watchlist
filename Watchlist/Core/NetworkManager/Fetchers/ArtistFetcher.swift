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

    private let artistService: ArtistService

    init(artistService: ArtistService = .shared) {
        self.artistService = artistService
    }

    func fetchSinglePage() async -> [Artist] {
        let nextPage = pageCounter + 1
        guard let artistsPage = await artistService.fetchArtists(page: nextPage), !Task.isCancelled else { return [] }
        pageCounter = nextPage
        return artistsPage.results ?? []
    }

    func fetchWithNextPage() async -> [Artist] {
        let artistsPage = await fetchSinglePage()
        self.artists.append(contentsOf: artistsPage)
        return self.artists
    }
}
