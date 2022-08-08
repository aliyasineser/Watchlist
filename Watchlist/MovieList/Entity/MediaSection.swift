//
//  MediaSection.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 14.06.2021.
//

import Foundation

enum MediaSection: CaseIterable {
    case popularMovies
    case mostRecentMovies
    case comingSoonMovies
    case airingTodaySeries
    case onTheAirSeries
    case topRatedSeries

    var type: MediaType {
        switch self {
        case .popularMovies:
            return .movie
        case .mostRecentMovies:
            return .movie
        case .comingSoonMovies:
            return .movie
        case .airingTodaySeries:
            return .tv
        case .onTheAirSeries:
            return .tv
        case .topRatedSeries:
            return .tv
        }
    }

}
