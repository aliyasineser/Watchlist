//
//  DiscoverInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import TMDBSwift

class DiscoverInteractor {
    
    private var popularPageCount: Int
    var popularMoviesList: [MovieMDB]
    
    init() {
        self.popularPageCount = 0
        self.popularMoviesList = []
    }
    
    /// Updates
    private func fetchNextPopularPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        
        popularPageCount += 1
        MovieMDB.popular(page: popularPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
            }
        }
    }
    
    /// Starts from the first page
    func fetchNextPopularPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        fetchNextPopularPage { (movies) in
            self.popularMoviesList.append(contentsOf: movies)
            completion(self.popularMoviesList)
        }
    }
    
}
