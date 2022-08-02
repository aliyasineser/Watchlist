//
//  CastEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation


class CastEntity: Identifiable {
    var id = UUID()
    var name: String
    var imageUrl: String
    var character: String
    
    internal init(imageUrl: String, name: String, character: String) {
        self.imageUrl = "https://" + imageUrl
        self.name = name
        self.character = character
    }
}
