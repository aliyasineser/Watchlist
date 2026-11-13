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
        let (data, response) = try await urlSession.data(for: data.request())
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidServerResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidServerResponse
        }
        return data
    }
}
