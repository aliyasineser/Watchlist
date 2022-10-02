//
//  TVRequest.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

enum TVRequest: MediaNetworkRequest {
    case getPopularSeries(page: Int)
    case getAiringTodaySeries(page: Int)
    case getOnTheAirSeries(page: Int)
    case getSeriesDetail(id: Int)
    case getSeriesReviews(id: Int, page: Int)
    case getSimilarSeriesTo(id: Int)
    case getCredits(id: Int)

    func mediaType() -> MediaType {
        .tv
    }

    var path: String {
        switch self {
        case .getPopularSeries:
            return "/tv/popular"
        case .getAiringTodaySeries:
            return "/tv/airing_today"
        case .getOnTheAirSeries:
            return "/tv/on_the_air"
        case .getSeriesDetail(id: let id):
            return "/tv/\(id)"
        case .getSeriesReviews(let id, _):
            return "/tv/\(id)/reviews"
        case .getSimilarSeriesTo(id: let id):
            return "/tv/\(id)/similar"
        case .getCredits(id: let id):
            return "/tv/\(id)/credits"
        }
    }

    var urlParams: [String: String?] {
        switch self {
        case .getPopularSeries(let page):
            return ["page": String(page),
                    "api_key": APIConstants.apiKey,
                    "language": APIConstants.language
            ]
        case .getAiringTodaySeries(let page):
            return ["page": String(page),
                    "api_key": APIConstants.apiKey,
                    "language": APIConstants.language
            ]
        case .getOnTheAirSeries(let page):
            return ["page": String(page),
                    "api_key": APIConstants.apiKey,
                    "language": APIConstants.language
            ]
        case .getSeriesDetail(id: let id):
            return ["tv_id": String(id),
                    "api_key": APIConstants.apiKey,
                    "append_to_response": "credits"
            ]
        case .getSeriesReviews(let id, let page):
            return ["tv_id": String(id),
                    "api_key": APIConstants.apiKey,
                    "language": APIConstants.language,
                    "page": String(page)
            ]
        case .getSimilarSeriesTo(id: let id):
            return ["tv_id": String(id),
                    "api_key": APIConstants.apiKey,
                    "append_to_response": "credits"
            ]
        case .getCredits(id: let id):
            return ["tv_id": String(id),
                    "api_key": APIConstants.apiKey,
                    "language": APIConstants.language
            ]
        }
    }

    var requestType: RequestType {
        .GET
    }
}
