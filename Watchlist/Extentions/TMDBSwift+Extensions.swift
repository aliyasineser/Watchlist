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


extension DiscoverMDB {
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

extension MovieMDB {
    
    func genresAsString() -> String {
        var genresList : [String] = [String]()
        genres.forEach { id, name in
            if let name = name {
                genresList.append(name)
            }
        }
        return genresList.joined(separator: " | ")
        
    }
}

extension TVMDB {
    func genresAsString() -> String {
        var genresList : [String] = [String]()
        genres.forEach { id, name in
            if let name = name {
                genresList.append(name)
            }
        }
        return genresList.joined(separator: " | ")
        
    }
}

extension CastCrewCommonMDB {
    
    func getPosterUrl() -> String {
        var url = ""
        if let profile_path = profile_path {
            url = TMDBUrl.imageBaseUrl + profile_path
        }
        return url
    }
    
}
