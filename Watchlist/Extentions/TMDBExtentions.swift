//
//  TMDBExtentions.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 4.06.2021.
//

import Foundation
import TMDBSwift


struct TMDBUrl {
    static let imageBaseUrl: String = "https://image.tmdb.org/t/p/w500/"
}

extension MovieMDB {
    func getPosterUrl() -> String {
        var url = ""
        if let pPath = poster_path {
            url = TMDBUrl.imageBaseUrl + pPath
        } else if let bPath = backdrop_path {
            url = TMDBUrl.imageBaseUrl + bPath
        }
        return url
    }
}

extension PersonMDB {
    func getPosterUrl() -> String {
        var url = ""
        if let pPath = profile_path {
            url = TMDBUrl.imageBaseUrl + pPath
        }
        return url
    }
}

extension PersonResults {
    func getPosterUrl() -> String {
        var url = ""
        if let pPath = profile_path {
            url = TMDBUrl.imageBaseUrl + pPath
        }
        return url
    }
}
