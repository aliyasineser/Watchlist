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
    func getGenresAsString() -> String {
        var genresString = ""
        
        GenresMDB.genres(listType: .movie, language: "en") { (ret, genres) in
            if let genreList = genres {
                if let ids = self.genre_ids {
                    genreList.forEach { (genre) in
                        if let id = genre.id, let name = genre.name {
                            if ids.contains(id) {
                                genresString = genresString  + " " + name + " | "
                            }
                        }
                    }
                }
                
            }
        }
//        genresString.remove(at: genresString.endIndex)
//        genresString.remove(at: genresString.endIndex)
        return genresString
    }
}

extension TVMDB {
    func getGenresAsString() -> String {
        var genresString = ""
        
        GenresMDB.genres(listType: .tv, language: "en") { (ret, genres) in
            if let genreList = genres {
                if let ids = self.genre_ids {
                    genreList.forEach { (genre) in
                        if let id = genre.id, let name = genre.name {
                            if ids.contains(id) {
                                genresString = genresString  + " " + name + " | "
                            }
                        }
                    }
                }
                
            }
        }
//        genresString.remove(at: genresString.endIndex)
//        genresString.remove(at: genresString.endIndex)
        return genresString
    }
}
