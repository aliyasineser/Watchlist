//
//  DiscoverFetchError.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 16.11.22.
//

import Foundation

enum FetchError: LocalizedError {
    case popularMovies

    var errorDescription: String? {
        switch self {
        case .popularMovies:
            return "Cannot Fetch Popular Movies"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .popularMovies:
            return "Because of a network or server issue, we couldn't fetch the popular movies"
        }
    }
}
