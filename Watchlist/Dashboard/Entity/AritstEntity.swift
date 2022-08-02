//
//  AritstEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

struct ArtistEntity: Identifiable {
    
    var id =  UUID()
    var artistId: Int
    var name: String
    var imageUrl: String
    
    
    internal init(artistId: Int, imageUrl: String, name: String) {
        self.artistId = artistId
        self.imageUrl = "https://" + imageUrl
        self.name = name
    }
}
