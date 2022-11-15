//
//  AuthService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 3.11.2022.
//

import Foundation

final class AuthService {

    private let requestManager: RequestManager

    public static let shared = AuthService()

    init(requestManager: RequestManager = DefaultRequestManager()) {
        self.requestManager = requestManager
    }

    func fetchRequestToken() async -> String {
        do {
            let authToken: NewAuthTokenResponse = try await requestManager.initRequest(with: AuthRequest.newAuthToken)
            guard authToken.success else { throw AuthError() }
            return authToken.requestToken
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }

    func buildPermissionUrl(requestToken: String) -> URL? {
        try? AuthPermissionRequest.askUserPermission(requestToken: requestToken).request().url
    }

    func fetchSessionId(requestToken: String) async -> String {
        do {
            let authToken: NewAuthSessionResponse = try await requestManager.initRequest(
                with: AuthRequest.newAuthSessionId(
                    requestToken: requestToken
                )
            )
            guard authToken.success else { throw AuthError() }
            return authToken.sessionID
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
}

final class AuthError: Error {

}
