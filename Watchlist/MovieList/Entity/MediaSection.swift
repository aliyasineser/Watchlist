//
//  MediaSection.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 14.06.2021.
//

import Foundation
import TMDBSwift


enum MediaSection: CaseIterable {
    case popularMovies
    case mostRecentMovies
    case comingSoonMovies
    case airingTodaySeries
    case onTheAirSeries
    case topRatedSeries


    var type: DiscoverMDB.Type {
        switch self {
        case .popularMovies:
            return MovieMDB.self
        case .mostRecentMovies:
            return MovieMDB.self
        case .comingSoonMovies:
            return MovieMDB.self
        case .airingTodaySeries:
            return TVMDB.self
        case .onTheAirSeries:
            return TVMDB.self
        case .topRatedSeries:
            return TVMDB.self
        }
    }

}
