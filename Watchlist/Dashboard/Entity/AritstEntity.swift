//
//  AritstEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

struct ArtistEntity: Identifiable {
    
    var id = UUID()
    var name: String
    var imageUrl: String
    
    
    internal init(imageUrl: String, name: String) {
        self.imageUrl = imageUrl
        self.name = name
    }
    
}
