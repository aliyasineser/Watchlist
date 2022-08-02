//
//  DiscoverInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation

class DiscoverInteractor {
    
    private var mediaFetcher: MediaFetcher
    
    init() {
        self.mediaFetcher = MediaFetcher()
    }
    
    /// Starts from the first page
    func fetchNextPopularPageAsFullList() async -> [Movie] {
        return await mediaFetcher.fetchNextPopularPageAsFullList()
    }
    
    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList() async -> [Movie] {
        return await mediaFetcher.fetchNextMostRecentPageAsFullList()
    }
    
    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList() async -> [Movie] {
        return await mediaFetcher.fetchNextUpcomingPageAsFullList()
    }
    
    /// Starts from the first page
    func fetcthAiringTodayPageAsFullList() async -> [TVSerie] {
        return await mediaFetcher.fetcthAiringTodayPageAsFullList()
    }
    
    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList() async -> [TVSerie] {
        return await mediaFetcher.fetcthOnTheAirPageAsFullList()
    }
    
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList() async -> [TVSerie] {
        return await mediaFetcher.fetcthTopRatedPageAsFullList()
    }
    
    
}

