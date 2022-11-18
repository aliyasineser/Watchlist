//
//  WathableEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol Watchable: Codable {
    var id: Int { get }
    var title: String { get }
    var voteAverage: Double? { get }
    var posterPath: String? { get }
    var backdropPath: String? { get }
    var overview: String? { get }
    var originalTitle: String? { get }
    var originalLanguage: OriginalLanguage? { get }
    var voteCount: Int? { get }
    var popularity: Double { get }

    var posterUrl: String { get }
}

extension Watchable {

    var posterUrl: String {
        APIConstants.defaultScheme +
        APIConstants.baseImgUrl +
        APIConstants.baseImgUrlPath +
        imagePath
    }

    var imagePath: String { return posterPath ?? backdropPath ?? "" }
}

protocol WatchableDetail: Watchable {
    var genres: [Genre] { get }
    var productionCompanies: [ProductionCompany]? { get }
    var productionCountries: [ProductionCountry]? { get }
    var tagline: String? { get }
    var credits: Credits? { get }
    var spokenLanguages: [SpokenLanguage]? { get }
    var homepage: String? { get }
}
