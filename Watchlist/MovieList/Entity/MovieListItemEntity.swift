//
//  MovieListItemEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 14.06.2021.
//

import Foundation


struct MovieListItemEntity: Identifiable {
    
    var id: Int
    var title: String
    var year: String
    var imgUrl: String
    var rating: Double
    var genres: String
    var mediaType: MediaType
    
    internal init(id: Int, title: String, year: String, imgUrl: String, rating: Double, genres: String, mediaType: MediaType) {
        self.id = id
        self.title = title
        self.year = year
        self.imgUrl = "https://" + imgUrl
        self.rating = rating
        self.genres = genres
        self.mediaType = mediaType
    }
}
