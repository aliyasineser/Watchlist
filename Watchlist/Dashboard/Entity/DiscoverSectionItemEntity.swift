//
//  DiscoverSectionItemEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.05.2021.
//

import Foundation

struct DiscoverSectionItemEntity: Identifiable {
    var id = UUID()
    var itemID: Int
    var title: String
    var year: String
    var imgUrl: String
    var genre: String
    var mediaType: MediaType

    init(id: Int, title: String, year: String, imgUrl: String, genre: String, mediaType: MediaType) {
        self.itemID = id
        self.title = title
        self.year = year
        self.imgUrl = imgUrl
        self.genre = genre
        self.mediaType = mediaType
    }
}

extension DiscoverSectionItemEntity {
    static let mock = DiscoverSectionItemEntity(id: 1,
                                                title: "Very Very  Movie Title ",
                                                year: "31 - 07 - 2021",
                                                imgUrl: "",
                                                genre: "Comedy",
                                                mediaType: .movie
    )
}
