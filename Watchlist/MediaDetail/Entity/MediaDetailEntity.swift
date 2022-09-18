//
//  MediaDetailEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 12.08.2021.
//

import Foundation

struct MediaDetailEntity: Identifiable {
    var id: Int
    var title: String
    var genres: String?
    var point: Double
    var language: String
    var date: String
    var time: String?
    var summary: String
    var imagePath: String
    var mediaType: MediaType

    init(id: Int = 0, title: String = "Title", genres: String? = nil,
         point: Double = 2.5, language: String = "en", date: String = "12.12.2012",
         time: String? = nil, summary: String = "Summary",
         imageUrl: String = "imageUrl", mediaType: MediaType = .movie) {
        self.id = id
        self.title = title
        self.genres = genres
        self.point = point
        self.language = language
        self.date = date
        self.time = time
        self.summary = summary
        self.imagePath = APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + imageUrl
        self.mediaType = mediaType
        if !imagePath.contains(APIConstants.defaultScheme) {
            self.imagePath = APIConstants.defaultScheme + self.imagePath

        }
    }
}
