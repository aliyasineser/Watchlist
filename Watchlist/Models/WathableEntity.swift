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
    func getReleaseDate() -> String?
    func getOverview() -> String
    func getVoteAverage() -> Double?
    func getID() -> Int
    func getPosterUrl() -> String
}

struct Media: Watchable, Codable, Identifiable {
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    var id: Int
    var mediaType: MediaType
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
        
    func getID() -> Int {
        return id
    }
    
    func getVoteAverage() -> Double? { return voteAverage }
    
    func getReleaseDate() -> String? { return releaseDate ?? firstAirDate }
    
    func getOverview() -> String { return overview }
}

protocol WatchableDetail: Codable {
    func getTitle() -> String
    func getImagePath() -> String
    func getReleaseDate() -> String?
    func getOverview() -> String
    func getVoteAverage() -> Double?
    func getID() -> Int
    func getPosterUrl() -> String
}

struct MediaDetail: Codable, WatchableDetail  {
    let id: Int
    let adult: Bool
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
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
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String?
    let inProduction: Bool
    let languages: [String]?
    let lastAirDate: String?
    let lastEpisodeToAir: LastEpisodeToAir?
    let name: String
    let nextEpisodeToAir: LastEpisodeToAir?
    let networks: [ProductionCompany]?
    let numberOfEpisodes, numberOfSeasons: Int?
    let originCountry: [String]?
    let originalName: String?
    let seasons: [Season]?
    let type: String?
    var mediaType: MediaType
    
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
        case mediaType = "media_type"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case releaseDate = "release_date"
        case revenue, runtime
        case spokenLanguages = "spoken_languages"
        case status, tagline, title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case originCountry = "origin_country"
        case originalName = "original_name"
        case seasons
        case type
        case numberOfSeasons = "number_of_seasons"
        
    }
    
    func getPosterUrl() -> String {
        return (posterPath ?? backdropPath ?? "")
    }
    
    func getTitle() -> String {
        return originalTitle
    }
    
    func getImagePath() -> String {
        return posterPath ?? backdropPath ?? ""
    }
        
    func getID() -> Int {
        return id
    }
    
    func getVoteAverage() -> Double? { return voteAverage }
    
    func getReleaseDate() -> String? { return releaseDate ?? firstAirDate }
    
    func getOverview() -> String { return overview ?? "" }
}
