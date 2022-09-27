//
//  MovieEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Watchable, Identifiable {
    let id: Int
    let title: String
    let adult: Bool?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    let genreIDS: [Int]
    let originalTitle: String?
    let originalLanguage: OriginalLanguage?
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
}

extension Movie {
    static let mock = Movie(
        id: 1,
        title: "Title", adult: true,
        posterPath: "posterPath",
        backdropPath: "backdropPath",
        overview: "Good movie",
        releaseDate: "01-01-2001",
        genreIDS: [],
        originalTitle: "Original Title",
        originalLanguage: nil,
        popularity: 10,
        voteCount: 6,
        video: false,
        voteAverage: 10000
    )
}

// MARK: - MovieDetail
struct MovieDetail: Codable, WatchableDetail, Identifiable {
    let id: Int
    let adult: Bool
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String
    let genres: [Genre]
    let belongsToCollection: Collection?
    let budget: Int
    var homepage: String?
    let imdbID: String?
    var originalLanguage: OriginalLanguage?
    let originalTitle: String?
    let popularity: Double
    var productionCompanies: [ProductionCompany]?
    var productionCountries: [ProductionCountry]?
    let revenue: Int
    let runtime: Int?
    var spokenLanguages: [SpokenLanguage]?
    let status, title: String
    var tagline: String?
    let video: Bool
    let voteAverage: Double?
    var voteCount: Int?
    var credits: Credits?

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

extension MovieDetail {
    static let mock = MovieDetail(
        id: 1,
        adult: true,
        posterPath: "posterPath",
        backdropPath: "backdropPath",
        overview: "overview",
        releaseDate: "01-01-1945",
        genres: [],
        belongsToCollection: nil,
        budget: 10000,
        homepage: "www.de.com",
        imdbID: "123",
        originalLanguage: .en,
        originalTitle: "Original Title",
        popularity: 10,
        productionCompanies: [],
        productionCountries: [],
        revenue: 100000,
        runtime: 123,
        spokenLanguages: [],
        status: "Status",
        title: "Title",
        tagline: "Tagline",
        video: false,
        voteAverage: 6.5,
        voteCount: 10000,
        credits: .mock
    )
}

// MARK: - Collection
struct Collection: Codable {
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
