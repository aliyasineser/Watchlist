//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

class ArtistInteractor {
    
    let artistFetcher: ArtistFetcher = ArtistFetcher()
   
    func fetchArtists() async -> [Artist] {
        return await artistFetcher.fetchWithNextPage()
    }
    
}
