//
//  MovieDetail.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

// MARK: - MovieDetail
struct MovieDetail: Codable, WatchableDetail, Identifiable, Equatable {
    let id: Int
    let adult: Bool
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: Date?
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

    internal init(
        id: Int,
        adult: Bool,
        posterPath: String? = nil,
        backdropPath: String? = nil,
        overview: String? = nil,
        releaseDate: Date?,
        genres: [Genre],
        belongsToCollection: Collection? = nil,
        budget: Int,
        homepage: String? = nil,
        imdbID: String? = nil,
        originalLanguage: OriginalLanguage? = nil,
        originalTitle: String? = nil,
        popularity: Double,
        productionCompanies: [ProductionCompany]? = nil,
        productionCountries: [ProductionCountry]? = nil,
        revenue: Int,
        runtime: Int? = nil,
        spokenLanguages: [SpokenLanguage]? = nil,
        status: String, title: String,
        tagline: String? = nil,
        video: Bool,
        voteAverage: Double? = nil,
        voteCount: Int? = nil,
        credits: Credits? = nil
    ) {
        self.id = id
        self.adult = adult
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.genres = genres
        self.belongsToCollection = belongsToCollection
        self.budget = budget
        self.homepage = homepage
        self.imdbID = imdbID
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.popularity = popularity
        self.productionCompanies = productionCompanies
        self.productionCountries = productionCountries
        self.revenue = revenue
        self.runtime = runtime
        self.spokenLanguages = spokenLanguages
        self.status = status
        self.title = title
        self.tagline = tagline
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.credits = credits
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.belongsToCollection = try container.decodeIfPresent(Collection.self, forKey: .belongsToCollection)
        self.budget = try container.decode(Int.self, forKey: .budget)
        self.genres = try container.decode([Genre].self, forKey: .genres)
        self.homepage = try container.decodeIfPresent(String.self, forKey: .homepage)
        self.id = try container.decode(Int.self, forKey: .id)
        self.imdbID = try container.decodeIfPresent(String.self, forKey: .imdbID)
        self.originalLanguage = try container.decodeIfPresent(OriginalLanguage.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.productionCompanies = try container.decodeIfPresent([ProductionCompany].self, forKey: .productionCompanies)
        self.productionCountries = try container.decodeIfPresent([ProductionCountry].self, forKey: .productionCountries)
        self.revenue = try container.decode(Int.self, forKey: .revenue)
        self.runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        self.spokenLanguages = try container.decodeIfPresent([SpokenLanguage].self, forKey: .spokenLanguages)
        self.status = try container.decode(String.self, forKey: .status)
        self.tagline = try container.decodeIfPresent(String.self, forKey: .tagline)
        self.title = try container.decode(String.self, forKey: .title)
        self.video = try container.decode(Bool.self, forKey: .video)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)
        self.credits = try container.decodeIfPresent(Credits.self, forKey: .credits)

        let release = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        self.releaseDate = formatter.date(from: release ?? "")
    }

}

// swiftlint:disable:all line_length
extension MovieDetail {
    static let mock = MovieDetail(
        id: 1,
        adult: true,
        posterPath: "posterPath",
        backdropPath: "backdropPath",
        overview:
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam orci neque, convallis id bibendum et, dignissim ut diam. In at eros imperdiet, pharetra dui sed, scelerisque est. In fringilla purus eget odio iaculis, nec semper dolor euismod. Curabitur aliquet elementum ligula ut consectetur. Maecenas interdum interdum orci at congue. Vestibulum molestie auctor fringilla. Pellentesque eros mauris, sodales quis sapien blandit, finibus vestibulum quam. Sed iaculis sit amet lorem vulputate aliquet. Aliquam maximus, tellus at laoreet consequat, lacus turpis ultricies orci, sit amet vulputate arcu dolor a magna. Ut sit amet ante turpis. In sit amet dolor porttitor, hendrerit urna non, fringilla nisl. Quisque elementum ac magna eu sodales. Aliquam at malesuada velit. Vestibulum eu purus at massa tempus gravida. Quisque vel leo scelerisque nisl vehicula posuere a at metus.

Nullam elit mauris, hendrerit et nunc at, interdum auctor nibh. Integer nec odio viverra magna sagittis pellentesque. Praesent hendrerit leo eget facilisis condimentum. In nec nisi sit amet felis luctus rutrum nec eget elit. Proin vel libero dui. Donec eu magna bibendum, ultricies felis vitae, vehicula purus. Nulla venenatis euismod enim id fringilla. Sed ipsum urna, tincidunt mollis libero nec, finibus lobortis libero. Donec quis posuere mauris, sed vestibulum ipsum. Pellentesque ultrices hendrerit ipsum, nec vulputate est ornare vitae. Mauris porttitor dolor sed turpis scelerisque, ut aliquet nisi ornare. Donec rhoncus, mauris in interdum aliquam, lorem ligula auctor odio, non rhoncus purus est sit amet felis. Curabitur pulvinar justo molestie, vulputate urna id, mollis justo. Nam blandit pulvinar mi, imperdiet lacinia lacus hendrerit non. Proin scelerisque lacus eu risus egestas, vel finibus erat ultricies.
""",
        releaseDate: .distantPast,
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
