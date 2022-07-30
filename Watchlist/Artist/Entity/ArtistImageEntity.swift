//
//  ArtistImageEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 30.10.2021.
//

import Foundation

struct ArtistImageEntity: Identifiable {
    var id = UUID()
    var aspect_ratio: Double
    var file_path: String
    var height: Int
    var iso_639_1: String
    var vote_average: Double
    var vote_count: Int
    var width: Int
    
    func getPosterUrl() -> String {
        var url = ""
        url = TMDBUrl.imageBaseUrl + file_path
        return url
    }
}
