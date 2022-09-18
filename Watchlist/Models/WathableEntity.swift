//
//  WathableEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol Watchable: Codable {
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

    func getPosterUrl() -> String {
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + getImagePath()
    }
}

extension Media {
    static let mock = Media(adult: true,
                            backdropPath: "",
                            genreIDS: [1], id: 1, mediaType: .movie,
                            originalLanguage: OriginalLanguage.en, originalTitle: "No way home",
                            posterPath: "", overview: "Nice movie ",
                            releaseDate: "2021 - 06 - 26", title: "No way home",
                            video: true, voteAverage: 5, voteCount: 5000000,
                            firstAirDate: "2021 - 05 - 21", name: "No way home",
                            originCountry: [], originalName: "No way home", popularity: 1000)
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

struct MediaDetail: Codable, WatchableDetail {
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

    func getPosterUrl() -> String { return (posterPath ?? backdropPath ?? "") }

    func getTitle() -> String { return originalTitle }

    func getImagePath() -> String { return posterPath ?? backdropPath ?? "" }

    func getID() -> Int { return id }

    func getVoteAverage() -> Double? { return voteAverage }

    func getReleaseDate() -> String? { return releaseDate ?? firstAirDate }

    func getOverview() -> String { return overview ?? "" }
}

extension MediaDetail {
    static let mock = MediaDetail(id: 1,
                                  adult: true,
                                  posterPath: "Poster Path",
                                  backdropPath: "Backdrop Path",
                                  overview: "Good Media",
                                  releaseDate: "01-01-1991",
                                  genres: [],
                                  belongsToCollection: nil,
                                  budget: 100000, homepage: "Homepage",
                                  imdbID: "IMDB-ID",
                                  originalLanguage: "Chinese",
                                  originalTitle: "Original Title",
                                  popularity: 10,
                                  productionCompanies: [],
                                  productionCountries: [],
                                  revenue: 1000000,
                                  runtime: 123,
                                  spokenLanguages: [],
                                  status: "Status",
                                  title: "Title",
                                  tagline: nil,
                                  video: false,
                                  voteAverage: 10,
                                  voteCount: 10,
                                  credits: nil,
                                  createdBy: [],
                                  episodeRunTime: [],
                                  firstAirDate: nil,
                                  inProduction: false,
                                  languages: [],
                                  lastAirDate: nil,
                                  lastEpisodeToAir: nil,
                                  name: "Name",
                                  nextEpisodeToAir: nil,
                                  networks: [],
                                  numberOfEpisodes: 123,
                                  numberOfSeasons: 123,
                                  originCountry: [],
                                  originalName: nil,
                                  seasons: [], type: nil,
                                  mediaType: .movie
    )
}
