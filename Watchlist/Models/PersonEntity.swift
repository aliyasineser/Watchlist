//
//  PersonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

protocol Creditable: Codable {
    func getTitle() -> String
    func getImagePath() -> String
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

struct Artist: Codable, Creditable {
    let adult: Bool
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday, deathday: String?
    let gender: Int?
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

    func getTitle() -> String { return name }

    func getImagePath() -> String { return profilePath ?? "" }
}

typealias Crew = Cast
struct Cast: Codable, Creditable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: Department?
    let name: String?
    let originalName: String?
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: Department?
    let job: String?
    let backdropPath: String?
    let genreIDS: [Int]
    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let posterPath: String?
    let releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

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
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    func getTitle() -> String { return title }

    func getImagePath() -> String { return posterPath ?? profilePath ?? "" }

    func getRole() -> String { return character ?? job ?? department?.rawValue ?? "" }
}
