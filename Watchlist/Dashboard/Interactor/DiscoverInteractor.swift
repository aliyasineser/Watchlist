//
//  DiscoverInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import TMDBSwift

class DiscoverInteractor {
    
    private var mediaFetcher: MediaFetcher
    
    
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

