//
//  ImageRequest.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

enum ImageRequest: NetworkRequest {
    case getImage(endpoint: String)

    var host: String {
        APIConstants.baseImgUrl
    }

    var path: String {
        switch self {
        case .getImage(let endpoint):
            return "/\(endpoint)"
        }
    }

    var urlParams: [String: String?] {
        switch self {
        case .getImage:
            return ["api_key": APIConstants.apiKey]
        }
    }

    var requestType: RequestType {
        .GET
    }
}
