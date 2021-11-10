//
//  MovieDetailEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 12.08.2021.
//

import Foundation
import TMDBSwift

struct MediaDetailEntity: Identifiable {
    var id: Int
    var title: String
    var genres: String
    var point: Double
    var language: String
    var date: String
    var time: String
    var summary: String
    var image_path: String
    var mediaType: MediaType
    
    init() {
        self.init(id: 0, title: "Title", genres: "Genres", point: 2.5, language: "en", date: "12.12.2012", time: "2h 15m", summary: "Summary", image_path: "", mediaType: .movie)
    }
    
    init(id: Int, title: String, genres: String, point: Double, language: String, date: String, time: String, summary: String, image_path: String, mediaType: MediaType) {
        self.id = id
        self.title = title
        self.genres = genres
        self.point = point
        self.language = language
        self.date = date
        self.time = time
        self.summary = summary
        self.image_path = image_path
        self.mediaType = mediaType
    }
    
}
