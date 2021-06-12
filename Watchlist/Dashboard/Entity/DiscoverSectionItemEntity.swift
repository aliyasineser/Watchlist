//
//  DiscoverSectionItemEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.05.2021.
//

import Foundation

struct DiscoverSectionItemEntity: Identifiable {
    var id: Int
    var title: String
    var year: String
    var imgUrl: String
    
    init(id: Int, title: String, year: String, imgUrl: String) {
        self.id = id
        self.title = title
        self.year = year
        self.imgUrl = imgUrl
    }
}
