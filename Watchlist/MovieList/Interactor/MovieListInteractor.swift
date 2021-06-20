//
//  MovieListInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import TMDBSwift

class MovieListInteractor {
    
    var mediaFetcher: MediaFetcher
    
    init() {
        self.mediaFetcher = MediaFetcher()
    }
    
    /// Starts from the first page
    func fetchNextPopularPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        mediaFetcher.fetchNextPopularPageAsFullList(updater: completion)
    }

    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        mediaFetcher.fetchNextMostRecentPageAsFullList(updater: completion)
    }

    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList(updater completion: @escaping ([MovieMDB]) -> Void ) -> Void {
        mediaFetcher.fetchNextUpcomingPageAsFullList(updater: completion)
    }
    
    /// Starts from the first page
    func fetcthAiringTodayPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        mediaFetcher.fetcthAiringTodayPageAsFullList(updater: completion)
    }
    
    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        mediaFetcher.fetcthOnTheAirPageAsFullList(updater: completion)
    }
    
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList(updater completion: @escaping ([TVMDB]) -> Void ) -> Void {
        mediaFetcher.fetcthTopRatedPageAsFullList(updater: completion)
    }
    
    
}


