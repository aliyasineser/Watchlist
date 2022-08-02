//
//  WathableEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol Watchable : Codable {
    func getTitle() -> String
    func getImagePath() -> String
}

struct Media: Watchable, Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    var id: Int
    var mediaType: MediaType?
    let originalLanguage: OriginalLanguage?
    let originalTitle: String?
    let posterPath: String?
    let overview: String
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int?
    let firstAirDate, name: String
    let originCountry: [String]
    let originalName: String?
    let popularity: Double
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case mediaType = "media_type"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case firstAirDate = "first_air_date"
        case name
        case popularity
        case originCountry = "origin_country"
        case originalName = "original_name"
    }
    
    func getTitle() -> String {
        return originalTitle ?? name
    }
    
    func getImagePath() -> String {
        return posterPath ?? backdropPath ?? ""
    }
}
