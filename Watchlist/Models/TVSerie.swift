//
//  TVSerieEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

struct TVSerie: Codable, Watchable, Identifiable {

    let id: Int
    let title: String
    let posterPath: String?
    let popularity: Double
    let backdropPath: String?
    let voteAverage: Double?
    let overview: String?
    let firstAirDate: Date?
    let originCountry: [OriginCountry]?
    let genreIDS: [Int]?
    let originalLanguage: OriginalLanguage?
    let voteCount: Int?
    let originalTitle: String?

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
        case title = "name"
        case originalTitle = "original_name"
    }

    internal init(
        id: Int,
        title: String,
        posterPath: String? = nil,
        popularity: Double,
        backdropPath: String? = nil,
        voteAverage: Double? = nil,
        overview: String? = nil,
        firstAirDate: Date? = nil,
        originCountry: [OriginCountry]? = nil,
        genreIDS: [Int]? = nil,
        originalLanguage: OriginalLanguage? = nil,
        voteCount: Int? = nil,
        originalTitle: String? = nil
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.popularity = popularity
        self.backdropPath = backdropPath
        self.voteAverage = voteAverage
        self.overview = overview
        self.firstAirDate = firstAirDate
        self.originCountry = originCountry
        self.genreIDS = genreIDS
        self.originalLanguage = originalLanguage
        self.voteCount = voteCount
        self.originalTitle = originalTitle
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.id = try container.decode(Int.self, forKey: .id)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.originCountry = try container.decodeIfPresent([OriginCountry].self, forKey: .originCountry)
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        self.originalLanguage = try container.decodeIfPresent(OriginalLanguage.self, forKey: .originalLanguage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.title = try container.decode(String.self, forKey: .title)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)

        let release = try container.decodeIfPresent(String.self, forKey: .firstAirDate)
        let formatter = DateFormatter.yyyyMMdd
        if let release, let date = formatter.date(from: release) {
            self.firstAirDate = date
        } else {
            throw DecodingError.dataCorruptedError(
                forKey: .firstAirDate,
                in: container,
                debugDescription: "Date string does not match format expected by formatter."
            )
        }
    }
}
