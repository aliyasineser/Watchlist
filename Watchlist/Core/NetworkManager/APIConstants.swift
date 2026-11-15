//
//  APIConstants.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

enum APIConstants {
    static let baseURL = "api.themoviedb.org"
    static let baseURLPath = "/3"

    static let authURL = "www.themoviedb.org"
    static let authURLPath = ""

    static let defaultScheme = "https://"

    static let baseImgUrl = "image.tmdb.org"
    static let baseImgUrlPath = "/t/p/w500"

    static let apiKey = loadAPIKey()
    static let language = "en-US"

    private static func loadAPIKey(bundle: Bundle = .main) -> String? {
        guard let url = bundle.url(forResource: "secret", withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return decodeAPIKey(from: data)
    }

    static func decodeAPIKey(from data: Data) -> String? {
        guard let configuration = try? JSONDecoder().decode(APIConfiguration.self, from: data),
              let key = configuration.apiKey?.trimmingCharacters(in: .whitespacesAndNewlines),
              !key.isEmpty else { return nil }
        return key
    }

    private struct APIConfiguration: Decodable {
        let apiKey: String?
    }
}
