//
//  Authentication.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.11.2022.
//

import Foundation

// MARK: - NewAuthTokenResponse
struct NewAuthTokenResponse: Codable {
    let success: Bool
    let expiresAt, requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}

// MARK: - NewAuthSessionResponse
struct NewAuthSessionResponse: Codable {
    let success: Bool
    let sessionID: String

    enum CodingKeys: String, CodingKey {
        case success
        case sessionID = "session_id"
    }
}
