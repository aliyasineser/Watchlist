//
//  WathableEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

enum ApiError: Error {
    case forbidden              //Status code 403
    case notFound               //Status code 404
    case conflict               //Status code 409
    case internalServerError    //Status code 500
}

protocol Watchable : Codable {
    func getTitle() -> String
    func getImagePath() -> String
}

struct Cast: Codable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: Department?
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: Department?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
}

struct PopularPeople : Codable {
    var page: Int
    var total_results: Int
    var total_pages: Int?
    var results: [Media]?
}

struct MovieDetail: Codable  {
    let adult: Bool
    let backdropPath: String?
    let belongsToCollection: Collection?
    let budget: Int
    let genres: [Genre]
    let homepage: String?
    let id: Int
    let imdbID: String?
    let originalLanguage, originalTitle: String
    let overview: String?
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let releaseDate: String
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
    
    init() {
        self.adult = false
        backdropPath = ""
        belongsToCollection = nil
        budget = 0
        genres = []
        homepage = ""
        id = 0
        imdbID  = ""
        originalLanguage = ""
        originalTitle = ""
        overview = ""
        popularity = 0.0
        posterPath = ""
        productionCompanies =  []
        productionCountries =  []
        releaseDate = ""
        revenue = 0
        runtime = 0
        spokenLanguages =  []
        status = ""
        tagline = ""
        title = ""
        video = false
        voteAverage = 0.0
        voteCount = 0
        credits = Credits()
    }
}

struct TvDetail: Codable {
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: String
    let genres: [Genre]
    let homepage: String
    let id: Int
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: String?
    let lastEpisodeToAir: LastEpisodeToAir?
    let name: String
    let nextEpisodeToAir: LastEpisodeToAir?
    let networks: [ProductionCompany]?
    let numberOfEpisodes, numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage, originalName, overview: String
    let popularity: Double
    let posterPath: String?
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    let spokenLanguages: [SpokenLanguage]?
    let status, tagline, type: String
    let voteAverage: Double
    let voteCount: Int
    let credits: Credits?
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case createdBy = "created_by"
        case episodeRunTime = "episode_run_time"
        case firstAirDate = "first_air_date"
        case genres, homepage, id
        case inProduction = "in_production"
        case languages
        case lastAirDate = "last_air_date"
        case lastEpisodeToAir = "last_episode_to_air"
        case name
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview, popularity
        case posterPath = "poster_path"
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case seasons
        case spokenLanguages = "spoken_languages"
        case status, tagline, type
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case credits
    }
    
    init() {
        createdBy = []
        backdropPath = ""
        genres = []
        homepage = ""
        id = 0
        originalLanguage = ""
        overview = ""
        popularity = 0.0
        posterPath = ""
        productionCompanies =  []
        productionCountries =  []
        spokenLanguages =  []
        status = ""
        tagline = ""
        voteAverage = 0.0
        voteCount = 0
        credits = Credits()
        type = ""
        episodeRunTime = []
        firstAirDate = ""
        inProduction = false
        languages = []
        lastAirDate = ""
        name = ""
        nextEpisodeToAir = LastEpisodeToAir()
        networks = []
        numberOfSeasons = 0
        numberOfEpisodes = 0
        originCountry = []
        originalName = ""
        seasons = []
        lastEpisodeToAir = LastEpisodeToAir()
    }
    
}

struct CreatedBy: Codable {
    let id: Int
    let creditID, name: String
    let gender: Int
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case creditID = "credit_id"
        case name, gender
        case profilePath = "profile_path"
    }
}

struct Season: Codable {
    let airDate: String?
    let episodeCount, id: Int
    let name, overview: String
    let posterPath: String?
    let seasonNumber: Int
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeCount = "episode_count"
        case id, name, overview
        case posterPath = "poster_path"
        case seasonNumber = "season_number"
    }
}

struct LastEpisodeToAir: Codable {
    let airDate: String?
    let episodeNumber, id: Int
    let name, overview, productionCode: String
    let seasonNumber: Int
    let stillPath: String?
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case airDate = "air_date"
        case episodeNumber = "episode_number"
        case id, name, overview
        case productionCode = "production_code"
        case seasonNumber = "season_number"
        case stillPath = "still_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    init() {
        airDate = ""
        episodeNumber = 0
        id = 0
        name = ""
        overview = ""
        productionCode = ""
        seasonNumber = 0
        stillPath = ""
        voteCount = 0
        voteAverage = 0.0
    }
}

struct MovieResponse : Codable {
    let dates: Dates?
    let page: Int
    var results: [Movie]
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVSerieResponse : Codable {
    let page: Int
    var results: [TVSerie]
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
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

