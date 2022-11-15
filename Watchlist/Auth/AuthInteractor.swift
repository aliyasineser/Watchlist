//
//  AuthInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.11.2022.
//

import Foundation

final class DefaultAuthInteractor {

    var requestToken: String = ""
    var sessionID: String = ""
    var authService: AuthService = .shared

    func fetchRequestToken() async -> String {
        self.requestToken = await authService.fetchRequestToken()
        return self.requestToken
    }

    func authPermissionUrl() -> URL? {
        authService.buildPermissionUrl(requestToken: self.requestToken)
    }

    func fetchSessionID() async -> String {
        self.sessionID = await authService.fetchSessionId(requestToken: self.requestToken)
        return self.sessionID
    }
}
