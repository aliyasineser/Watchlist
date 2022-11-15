//
//  AuthPermissionRequest.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.11.2022.
//

import Foundation


enum AuthPermissionRequest: AuthNetworkRequest {
    case askUserPermission(requestToken: String)

    var path: String {
        switch self {
        case .askUserPermission(let requestToken):
            return "/authenticate/\(requestToken)"
        }
    }

    var urlParams: [String: String?] {
        switch self {
        case .askUserPermission:
            return [:]
        }
    }

    var params: [String: Any] {
        switch self {
        case .askUserPermission:
            return [:]
        }
    }

    var requestType: RequestType {
        switch self {
        case .askUserPermission:
            return .GET
        }
    }
}
