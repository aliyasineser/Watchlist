//
//  TVSerieCommon.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

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

    let airDate: Date?
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

    internal init(
        airDate: Date? = nil,
        episodeNumber: Int,
        id: Int,
        name: String,
        overview: String,
        productionCode: String,
        seasonNumber: Int,
        stillPath: String? = nil,
        voteAverage: Double,
        voteCount: Int
    ) {
        self.airDate = airDate
        self.episodeNumber = episodeNumber
        self.id = id
        self.name = name
        self.overview = overview
        self.productionCode = productionCode
        self.seasonNumber = seasonNumber
        self.stillPath = stillPath
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.episodeNumber = try container.decode(Int.self, forKey: .episodeNumber)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.overview = try container.decode(String.self, forKey: .overview)
        self.productionCode = try container.decode(String.self, forKey: .productionCode)
        self.seasonNumber = try container.decode(Int.self, forKey: .seasonNumber)
        self.stillPath = try container.decodeIfPresent(String.self, forKey: .stillPath)
        self.voteAverage = try container.decode(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decode(Int.self, forKey: .voteCount)

        let formatter = DateFormatter.yyyyMMdd

        let release = try container.decodeIfPresent(String.self, forKey: .airDate)
        if let release, let date = formatter.date(from: release) {
            self.airDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .airDate,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}
