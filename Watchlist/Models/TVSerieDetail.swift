//
//  TVSerieDetail.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation


struct TvDetail: Codable, WatchableDetail, Identifiable {
    let id: Int
    let backdropPath: String?
    let createdBy: [CreatedBy]?
    let episodeRunTime: [Int]?
    let firstAirDate: Date?
    let genres: [Genre]
    var homepage: String?
    let inProduction: Bool
    let languages: [String]
    let lastAirDate: Date?
    let lastEpisodeToAir: LastEpisodeToAir?
    let title: String
    let nextEpisodeToAir: LastEpisodeToAir?
    let networks: [ProductionCompany]?
    let numberOfEpisodes, numberOfSeasons: Int
    let originCountry: [String]
    let originalLanguage: OriginalLanguage?
    let overview: String?
    let originalTitle: String?
    let popularity: Double
    let posterPath: String?
    var productionCompanies: [ProductionCompany]?
    var productionCountries: [ProductionCountry]?
    let seasons: [Season]?
    var spokenLanguages: [SpokenLanguage]?
    var status, tagline, type: String?
    let voteAverage: Double?
    var voteCount: Int?
    var credits: Credits?

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
        case title = "name"
        case nextEpisodeToAir = "next_episode_to_air"
        case networks
        case numberOfEpisodes = "number_of_episodes"
        case numberOfSeasons = "number_of_seasons"
        case originCountry = "origin_country"
        case originalLanguage = "original_language"
        case originalTitle = "original_name"
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

    internal init(
        id: Int,
        backdropPath: String? = nil,
        createdBy: [CreatedBy]? = nil,
        episodeRunTime: [Int]? = nil,
        firstAirDate: Date?,
        genres: [Genre],
        homepage: String? = nil,
        inProduction: Bool,
        languages: [String],
        lastAirDate: Date? = nil,
        lastEpisodeToAir: LastEpisodeToAir? = nil,
        title: String,
        nextEpisodeToAir: LastEpisodeToAir? = nil,
        networks: [ProductionCompany]? = nil,
        numberOfEpisodes: Int,
        numberOfSeasons: Int,
        originCountry: [String],
        originalLanguage: OriginalLanguage? = nil,
        overview: String? = nil,
        originalTitle: String? = nil,
        popularity: Double,
        posterPath: String? = nil,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        seasons: [Season]? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        status: String? = nil,
        tagline: String? = nil,
        type: String? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        credits: Credits? = nil
    ) {
        self.id = id
        self.backdropPath = backdropPath
        self.createdBy = createdBy
        self.episodeRunTime = episodeRunTime
        self.firstAirDate = firstAirDate
        self.genres = genres
        self.homepage = homepage
        self.inProduction = inProduction
        self.languages = languages
        self.lastAirDate = lastAirDate
        self.lastEpisodeToAir = lastEpisodeToAir
        self.title = title
        self.nextEpisodeToAir = nextEpisodeToAir
        self.networks = networks
        self.numberOfEpisodes = numberOfEpisodes
        self.numberOfSeasons = numberOfSeasons
        self.originCountry = originCountry
        self.originalLanguage = originalLanguage
        self.overview = overview
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.posterPath = posterPath
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.seasons = seasons
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.tagline = tagline
        self.type = type
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.credits = credits
    }

    // swiftlint:disable:all function_body_length
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.createdBy = try container.decodeIfPresent([CreatedBy].self, forKey: .createdBy)
        self.episodeRunTime = try container.decodeIfPresent([Int].self, forKey: .episodeRunTime)
        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.inProduction = try container.decode(Bool.self, forKey: .inProduction)
        self.languages = try container.decode([String].self, forKey: .languages)
        self.lastEpisodeToAir = try container.decodeIfPresent(LastEpisodeToAir.self, forKey: .lastEpisodeToAir)
        self.title = try container.decode(String.self, forKey: .title)
        self.nextEpisodeToAir = try container.decodeIfPresent(LastEpisodeToAir.self, forKey: .nextEpisodeToAir)
        self.networks = try container.decodeIfPresent([ProductionCompany].self, forKey: .networks)
        self.numberOfEpisodes = try container.decode(Int.self, forKey: .numberOfEpisodes)
        self.numberOfSeasons = try container.decode(Int.self, forKey: .numberOfSeasons)
        self.originCountry = try container.decode([String].self, forKey: .originCountry)
        self.originalLanguage = try container.decodeIfPresent(OriginalLanguage.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        self.seasons = try container.decodeIfPresent([Season].self, forKey: .seasons)
        self.spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.credits = try container.decodeIfPresent(Credits.self, forKey: .credits)

        let formatter = DateFormatter.yyyyMMdd

        let firstRelease = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        self.firstAirDate = formatter.date(from: firstRelease ?? "")

        let lastRelease = try container.decodeIfPresent(String.self, forKey: .lastAirDate)
        self.lastAirDate = formatter.date(from: lastRelease ?? "")
    }
}

extension TvDetail {
    static let mock = TvDetail(
        id: 1, backdropPath: "Backdrop",
        createdBy: [],
        episodeRunTime: [1, 2, 3],
        firstAirDate: .distantPast,
        genres: [],
        homepage: "",
        inProduction: false,
        languages: ["en"],
        lastAirDate: .distantPast,
        lastEpisodeToAir: nil,
        title: "TV Serie",
        nextEpisodeToAir: nil,
        networks: [],
        numberOfEpisodes: 10,
        numberOfSeasons: 5,
        originCountry: [],
        originalLanguage: .en,
        overview: "Good serie",
        originalTitle: "TV Serie original name",
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
