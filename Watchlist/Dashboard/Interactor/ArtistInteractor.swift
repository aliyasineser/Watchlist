//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

class ArtistInteractor {
    var artists: [Artist]
    private var artistsPageCount: Int
    
    let artistService = ArtistService(requestManager: RequestManager())
    
    init() {
        self.artists = []
        self.artistsPageCount = 0
    }
    
    func fetchArtists() async -> [Artist] {
        self.artistsPageCount += 1
        let artstResults = await artistService.fetchArtists(page: artistsPageCount)
        if let artists = artstResults?.results {
            self.artists.append(contentsOf: artists)
            return artists
        } else {
            return []
        }
        
    }
    
}
