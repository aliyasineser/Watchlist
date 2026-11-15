//
//  NetworkError.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

public enum NetworkError: LocalizedError, Equatable {
    case invalidServerResponse
    case invalidURL
    case missingAPIKey
    case httpError(status: Int)
    public var errorDescription: String? {
        switch self {
        case .invalidServerResponse:
            return "The server returned an invalid response."
        case .invalidURL:
            return "URL string is malformed."
        case .missingAPIKey:
            return "Movie catalog access is not configured in this build. Add a valid TMDB API key and rebuild."
        case .httpError(let status):
            switch status {
            case 401, 403:
                return "The movie service rejected this build’s credentials (HTTP \(status)). Check the TMDB API key."
            case 404:
                return "This item is no longer available from the movie service (HTTP 404)."
            case 429:
                return "Too many requests to the movie service. Wait a moment and try again (HTTP 429)."
            case 500...599:
                return "The movie service is temporarily unavailable (HTTP \(status)). Please try again later."
            default:
                return "The movie service request failed (HTTP \(status))."
            }
        }
    }
}
