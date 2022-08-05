//
//  MovieEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

struct Movie: Codable, Watchable {
    let id: Int
    let adult: Bool?
    let posterPath: String?
    let backdropPath: String?
    let overview: String
    let releaseDate: String?
    let genreIDS: [Int]
    let originalTitle: String?
    let originalLanguage: OriginalLanguage?
    let title: String
    let popularity: Double
    let voteCount: Int?
    let video: Bool
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    func getTitle() -> String { return title }
    
    func getImagePath() -> String { return posterPath ?? backdropPath ?? "" }
        
    func getVoteAverage() -> Double? { return voteAverage }

    func getReleaseDate() -> String? { return releaseDate ?? nil }
    
    func getOverview() -> String { return overview }
    
    func getID() -> Int {
        return id
    }
}

struct MovieDetail: Codable  {
    let id: Int
    let adult: Bool
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String
    let genres: [Genre]
    let belongsToCollection: Collection?
    let budget: Int
    let homepage: String?
    let imdbID: String?
    let originalLanguage, originalTitle: String
    let popularity: Double
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let revenue: Int
    let runtime: Int?
    let spokenLanguages: [SpokenLanguage]?
    let status, title: String
    let tagline: String?
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case belongsToCollection = "belongs_to_collection"
        case budget, genres, homepage, id
        case imdbID = "imdb_id"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits
    }
}

struct Collection : Codable {
    let backdropPath: String?
    var id: Int
    let name: String
    let posterPath: String?
    let overview: String?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case overview
        case posterPath = "poster_path"
        case name
    }
}
