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
    
    private var mostRecentPageCount: Int
    var mostRecentList: [MovieMDB]
    
    private var comingSoonPageCount: Int
    var comingSoonList: [MovieMDB]
    
    init() {
        self.popularPageCount = 0
        self.popularMoviesList = []
        
        self.mostRecentPageCount = 0
        self.mostRecentList = []
        
        self.comingSoonPageCount = 0
        self.comingSoonList = []
    }
    
    /// Popular Page
    // Update
    private func fetchNextPopularPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        
        popularPageCount += 1
        MovieMDB.popular(page: popularPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
                debugPrint("Popular")
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

    /// Most Recent Page
    // Updates
    private func fetchNextMostRecentPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        self.mostRecentPageCount += 1
        MovieMDB.nowplaying(page: mostRecentPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
                debugPrint("NowPlaying")
            }
        }
    }
    
    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        fetchNextMostRecentPage { (movies) in
            self.mostRecentList.append(contentsOf: movies)
            completion(self.mostRecentList)
        }
    }
    
    /// Upcoming Page
    // Updates
    private func fetchUpcomingPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        self.comingSoonPageCount += 1
        MovieMDB.upcoming(page: comingSoonPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
                debugPrint("Upcoming")
            }
        }
    }
    
    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        fetchUpcomingPage { (movies) in
            self.comingSoonList.append(contentsOf: movies)
            completion(self.comingSoonList)
        }
    }
    
    
}

