//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import TMDBSwift

class MediaCastInteractor {
    var artists: [PersonResults]
    private var artistsPageCount: Int
    
    init() {
        self.artists = []
        self.artistsPageCount = 0
    }
    
    func fetchArtists(_ completion: @escaping (([PersonResults])-> Void)) -> Void {
        self.artistsPageCount += 1
        PersonMDB.popular(page: self.artistsPageCount) { (ret, artistResults) in
            if let artists = artistResults {
                self.artists.append(contentsOf: artists)
                completion(artists)
            }
        }
    }
    
}
