//
//  ResponseEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

struct GenreResponse: Codable {
    var genres: [Genre]?
}

struct ArtistDetail: Codable, Identifiable {
    let birthday, knownForDepartment: String?
    let deathday: String?
    let id: Int
    let name: String
    let alsoKnownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool
    let imdbID: String?
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }

    func getPosterUrl() -> String {
        APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (profilePath ?? "")
    }
}

extension ArtistDetail {
    static let mock = ArtistDetail(
        birthday: "01-01-1994",
        knownForDepartment: "Department",
        deathday: "01-01-2009",
        id: 1,
        name: "Name",
        alsoKnownAs: [],
        gender: 1,
        biography: "Biography",
        popularity: 10,
        placeOfBirth: "Place",
        profilePath: "ProfilePath",
        adult: false,
        imdbID: "IMDB ID",
        homepage: "www.homepage.com"
    )
}

// MARK: - ArtistImageResponse
struct ArtistImageResponse: Codable {
    let id: Int
    let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: String? // swiftlint:disable:this identifier_name
    let voteAverage: Double
    let voteCount, width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1" // swiftlint:disable:this identifier_name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }
}

struct Dates: Codable {
    let maximum, minimum: String
}

struct MovieResponse: Codable {
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

struct TVSerieResponse: Codable {
    let page: Int
    var results: [TVSerie]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
