//
//  GenreEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 6.06.2021.
//

import Foundation

struct GenreEntity: Identifiable {
    
    var id: Int
    var name: String
    
    internal init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
}
