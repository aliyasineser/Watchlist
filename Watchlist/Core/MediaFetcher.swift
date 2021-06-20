//
//  MediaFetcher.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import TMDBSwift

class MediaFetcher {
    
    private var popularPageCount: Int
    var popularMoviesList: [MovieMDB]
    
    private var mostRecentPageCount: Int
    var mostRecentList: [MovieMDB]
    
    private var comingSoonPageCount: Int
    var comingSoonList: [MovieMDB]
    
    private var airingTodayPageCount: Int
    var airingTodayList: [TVMDB]
    
    private var onTheAirPageCount: Int
    var OnTheAirList: [TVMDB]
    
    private var topRatedPageCount: Int
    var topRatedList: [TVMDB]
    
    init() {
        self.popularPageCount = 0
        self.popularMoviesList = []
        
        self.mostRecentPageCount = 0
        self.mostRecentList = []
        
        self.comingSoonPageCount = 0
        self.comingSoonList = []
        
        self.airingTodayPageCount = 0
        self.airingTodayList = []
        
        self.onTheAirPageCount = 0
        self.OnTheAirList = []
        
        self.topRatedPageCount = 0
        self.topRatedList = []
    }
    
    /// Popular Page
    // Update
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

    /// Most Recent Page
    // Updates
    func fetchNextMostRecentPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        self.mostRecentPageCount += 1
        MovieMDB.nowplaying(page: mostRecentPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
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
    func fetchUpcomingPage(_ completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        self.comingSoonPageCount += 1
        MovieMDB.upcoming(page: comingSoonPageCount) { (data, movies) in
            if let movieList = movies {
                completion(movieList)
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
    
    /// Airing Today
    // Updates
    func fetcthAiringTodayPage(_ completion: @escaping ([TVMDB]) -> Void ) -> Void {
        self.airingTodayPageCount += 1
        TVMDB.airingtoday(page: self.airingTodayPageCount, language: "end", timezone: nil) { (data, series) in
            if let tvList = series {
                completion(tvList)
            }
        }
    }
    
    /// Starts from the first page
    func fetcthAiringTodayPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        fetcthAiringTodayPage { (series) in
            self.airingTodayList.append(contentsOf: series)
            completion(self.airingTodayList)
        }
    }
    
    /// On The Air
    // Updates
    func fetcthOnTheAirPage(_ completion: @escaping ([TVMDB]) -> Void ) -> Void {
        self.onTheAirPageCount += 1
        TVMDB.ontheair(page: self.onTheAirPageCount, language: "en") { (data, series) in
            if let tvList = series {
                completion(tvList)
            }
        }
    }
    
    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        fetcthOnTheAirPage { (series) in
            self.OnTheAirList.append(contentsOf: series)
            completion(self.OnTheAirList)
        }
    }
    
    /// Airing Today
    // Updates
    func fetcthTopRatedPage(_ completion: @escaping ([TVMDB]) -> Void ) -> Void {
        self.topRatedPageCount += 1
        TVMDB.toprated(page: self.topRatedPageCount, language: "en") { (data, series) in
            if let tvList = series {
                completion(tvList)
            }
        }
    }
    
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        fetcthTopRatedPage { (series) in
            self.topRatedList.append(contentsOf: series)
            completion(self.topRatedList)
        }
    }
    
    
}

