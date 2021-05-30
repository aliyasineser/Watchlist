//
//  DiscoverSectionItemEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.05.2021.
//

import Foundation

struct DiscoverSectionItemEntity {
    var title: String
    var year: String
    var imgUrl: String
    
    init(title: String, year: String, imgUrl: String) {
        self.title = title
        self.year = year
        self.imgUrl = imgUrl
    }
}
