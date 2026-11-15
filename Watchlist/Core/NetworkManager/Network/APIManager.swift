//
//  APIManager.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol APIManager {
    func initRequest(with data: NetworkRequest) async throws -> Data
}

class DefaultAPIManager: APIManager {
    private let urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func initRequest(with data: NetworkRequest) async throws -> Data {
        let request = try data.request()
        try Self.validateCredentials(for: request)
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(status: httpResponse.statusCode)
        }
        return data
    }

    static func validateCredentials(for request: URLRequest) throws {
        guard request.url?.host == APIConstants.baseURL else { return }
        let components = request.url.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
        let hasKey = components?.queryItems?.contains {
            $0.name == "api_key" && !($0.value?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty
        } ?? false
        let authorization = request.value(forHTTPHeaderField: "Authorization")?.split(separator: " ", maxSplits: 1)
        let hasBearer = authorization?.count == 2 && authorization?.first?.lowercased() == "bearer" &&
            !(authorization?.last?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "").isEmpty
        guard hasKey || hasBearer else { throw NetworkError.missingAPIKey }
    }

}
