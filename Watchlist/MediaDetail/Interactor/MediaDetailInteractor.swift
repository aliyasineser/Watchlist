//
//  MovieDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation
import TMDBSwift


class MediaDetailInteractor {
    
    func getMovieDetail(_ id: Int, completion: @escaping (MovieDetailedMDB?) -> Void ) -> Void {
        MovieMDB.movie(movieID: id, language: "en") { retCode, detail in
            completion(detail)
        }
    }
    
    func getTvDetail(_ id: Int, completion: @escaping (TVDetailedMDB?) -> Void ) -> Void {
        TVDetailedMDB.tv(tvShowID: id, language: "en") { retCode, detail in
            completion(detail)
        }
    }
}
