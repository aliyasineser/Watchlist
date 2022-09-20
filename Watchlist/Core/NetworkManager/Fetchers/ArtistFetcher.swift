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

    init(requestManager: RequestManager) {
        self.artistService = ArtistService(requestManager: requestManager)
    }

    func fetchSinglePage() async -> [Artist] {
        pageCounter += 1
        let artistsPage = await artistService.fetchArtists(page: pageCounter)
        if let artists = artistsPage?.results { return artists } else { return [] }
    }

    func fetchWithNextPage() async -> [Artist] {
        let artistsPage = await fetchSinglePage()
        self.artists.append(contentsOf: artistsPage)
        return self.artists
    }
}
