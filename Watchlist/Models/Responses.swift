//
//  ResponseEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

// MARK: - GenreResponse
struct GenreResponse: Codable {
    var genres: [Genre]?
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

    func getPosterUrl() -> String {
        APIConstants.defaultScheme + APIConstants.baseImgUrl +
        APIConstants.baseImgUrlPath + filePath
    }
}

extension Profile {
    static let mock = Profile(
        aspectRatio: 1,
        filePath: "File Path",
        height: 200,
        iso639_1: "en-US",
        voteAverage: 5,
        voteCount: 10,
        width: 200
    )
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - MovieResponse
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

// MARK: - TVSerieResponse
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
