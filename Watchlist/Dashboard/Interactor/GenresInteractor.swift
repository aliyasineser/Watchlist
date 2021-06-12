//
//  GenresInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 6.06.2021.
//

import Foundation
import TMDBSwift

class GenresInteractor {
    
    var genres: [GenresMDB]
    
    init() {
        self.genres = []
    }
    
    func fetchGenres(_ completion: @escaping (([GenresMDB])-> Void)) -> Void {
        GenresMDB.genres(listType: .movie, language: "en") { (ret, genres) in
            if let genreList = genres {
                self.genres = genreList
                completion(self.genres)
            }
        }
    }
    
}
