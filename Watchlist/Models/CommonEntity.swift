//
//  CommonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

struct Credits: Codable {
    let cast, crew: [Cast]
    let id: Int?
    
    init() {
        cast = []
        crew = []
        id = 0
    }
}

struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String
    
    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1"
        case name
    }
}

struct ProductionCountry: Codable {
    let iso3166_1, name: String
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}

struct Genre : Codable {
    var id : Int;
    var name : String;
}

struct Company : Codable {
    var id : Int;
    var name : String;
    var logoPath : String;
    var originCountry : String;
}

struct Production : Codable {
    var iso3166_1 : String;
    var name : String;
}


struct Dates: Codable {
    let maximum, minimum: String
}

struct Crew : Codable {
    var credit_id: String
    var department: String
    var gender: Int
    var id: Int
    var job: String
    var name: String
    var profile_path: String
}


enum Department: String, Codable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
    case lighting = "Lighting"
    case creator = "Creator"
}

struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}


struct PopularArtists: Codable {
    let page: Int
    let results: [Artist]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Artist: Codable {
    let adult: Bool
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday, deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbID, knownForDepartment: String?
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}

struct TVSerie: Codable, Watchable {
    let posterPath: String?
    let popularity: Double
    let id: Int
    let backdropPath: String?
    let voteAverage: Double?
    let overview: String
    let firstAirDate: String?
    let originCountry: [OriginCountry]?
    let genreIDS: [Int]?
    let originalLanguage: OriginalLanguage?
    let voteCount: Int?
    let name: String
    let originalName: String?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case overview
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case voteCount = "vote_count"
        case name
        case originalName = "original_name"
    }
    
    func getTitle() -> String {
        return name
    }
    
    func getImagePath() -> String {
        return posterPath ?? backdropPath ?? ""
    }
}

struct Movie: Codable, Watchable {
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String?
    let genreIDS: [Int]?
    let id: Int
    let originalTitle: String?
    let originalLanguage: OriginalLanguage?
    let title: String
    let backdropPath: String?
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
    
    func getTitle() -> String {
        return title
    }
    
    func getImagePath() -> String {
        return posterPath ?? backdropPath ?? ""
    }
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
