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

    static private func loadAPIKey(jsonFileName: String = "secret") -> String? {
        if let path = Bundle.main.path(forResource: jsonFileName, ofType: "json") {
            if let jsonData = try? NSData(contentsOfFile: path, options: .mappedIfSafe) {
                if let jsonResult: NSDictionary =
                    try? JSONSerialization.jsonObject(
                        with: jsonData as Data,
                        options: .mutableContainers
                    ) as? NSDictionary {
                    if let apiKey: NSString = jsonResult["apiKey"] as? NSString {
                        return String(apiKey)
                    }
                }
            }
        }
        return nil
    }
}
