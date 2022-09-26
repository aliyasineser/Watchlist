//
//  TVSerieEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

struct TvDetail: Codable, WatchableDetail {
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

    func getTitle() -> String { return name }

    func getImagePath() -> String { return posterPath ?? backdropPath ?? "" }

    func getVoteAverage() -> Double? { return voteAverage }

    func getID() -> Int { return id }

    func getReleaseDate() -> String? { return firstAirDate }

    func getOverview() -> String { return overview }

    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + getImagePath()
    }
}

extension TvDetail {
    static let mock = TvDetail(
        backdropPath: "Backdrop",
        createdBy: [],
        episodeRunTime: [1, 2, 3],
        firstAirDate: "01-01-1994",
        genres: [],
        homepage: "",
        id: 1,
        inProduction: false,
        languages: ["en"],
        lastAirDate: "01-04-2001",
        lastEpisodeToAir: nil,
        name: "TV Serie",
        nextEpisodeToAir: nil,
        networks: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 5,
        originCountry: [],
        originalLanguage: "en",
        originalName: "TV Serie original name",
        overview: "Good serie",
        popularity: 5,
        posterPath: "postar path",
        productionCompanies: [],
        productionCountries: [],
        seasons: [],
        spokenLanguages: [],
        status: "online",
        tagline: "tagline",
        type: "type",
        voteAverage: 9,
        voteCount: 1000,
        credits: nil
    )
}

struct CreatedBy: Codable {
    let id: Int
    let creditID, name: String
    let gender: Int?
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
}

struct TVSerie: Codable, Watchable, Identifiable {
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

    func getTitle() -> String { return name }

    func getImagePath() -> String { return posterPath ?? backdropPath ?? "" }

    func getVoteAverage() -> Double? { return voteAverage }

    func getID() -> Int { return id }

    func getReleaseDate() -> String? { return firstAirDate }

    func getOverview() -> String { return overview }
}
