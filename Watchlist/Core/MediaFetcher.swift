//
//  MediaFetcher.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

protocol MediaFetchManager {
    
    var pageCounter: Int { get set }
    
    func fetchSignlePage() async -> [Watchable]
    func fetchWithLastPage() async -> [Watchable]
    
}


class MediaFetcher {
    
    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())
    
    private var popularPageCount: Int
    var popularMoviesList: [Movie]
    
    private var mostRecentPageCount: Int
    var mostRecentList: [Movie]
    
    private var comingSoonPageCount: Int
    var comingSoonList: [Movie]
    
    private var airingTodayPageCount: Int
    var airingTodayList: [TVSerie]
    
    private var onTheAirPageCount: Int
    var OnTheAirList: [TVSerie]
    
    private var topRatedPageCount: Int
    var topRatedList: [TVSerie]
    
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
    private func fetchNextPopularPage() async -> [Movie] {
        popularPageCount += 1
        return await movieService.fetchPopularMovies(page: popularPageCount)
    }
    
    /// Starts from the first page
    func fetchNextPopularPageAsFullList() async -> [Movie] {
        let movies = await fetchNextPopularPage()
        self.popularMoviesList.append(contentsOf: movies)
        return self.popularMoviesList
    }
    
    /// Most Recent Page
    // Updates
    func fetchNextMostRecentPage() async -> [Movie] {
        mostRecentPageCount += 1
        return await movieService.fetchNowPlayingMovies(page: mostRecentPageCount)
    }
    
    /// Starts from the first page
    func fetchNextMostRecentPageAsFullList() async -> [Movie] {
        let movies = await fetchNextMostRecentPage()
        self.mostRecentList.append(contentsOf: movies)
        return self.mostRecentList
    }
    
    /// Upcoming Page
    // Updates
    func fetchUpcomingPage() async -> [Movie] {
        self.comingSoonPageCount += 1
        return await movieService.fetchUpcomingMovies(page: comingSoonPageCount)
    }
    
    /// Starts from the first page
    func fetchNextUpcomingPageAsFullList() async -> [Movie] {
        let movies = await fetchUpcomingPage()
        self.comingSoonList.append(contentsOf: movies)
        return self.comingSoonList
    }
    
    /// Airing Today
    // Updates
    func fetcthAiringTodayPage() async -> [TVSerie] {
        airingTodayPageCount += 1
        return await tvService.fetchAiringTodaySeries(page: airingTodayPageCount)
    }
    
    /// Starts from the first page
    func fetcthAiringTodayPageAsFullList() async -> [TVSerie] {
        let series = await fetcthAiringTodayPage()
        self.airingTodayList.append(contentsOf: series)
        return self.airingTodayList
    }
    
    /// On The Air
    // Updates
    func fetcthOnTheAirPage() async -> [TVSerie] {
        self.onTheAirPageCount += 1
        return await tvService.fetchOnTheAirSeries(page: onTheAirPageCount)
    }
    
    /// Starts from the first page
    func fetcthOnTheAirPageAsFullList() async -> [TVSerie] {
        let series = await fetcthOnTheAirPage()
        self.OnTheAirList.append(contentsOf: series)
        return self.OnTheAirList
    }
    
    /// Airing Today
    // Updates
    func fetcthTopRatedPage() async -> [TVSerie] {
        self.topRatedPageCount += 1
        return await tvService.fetchPopularSeries(page: topRatedPageCount)
    }
    
    /// Starts from the first page
    func fetcthTopRatedPageAsFullList() async -> [TVSerie] {
        let series = await fetcthTopRatedPage()
        self.topRatedList.append(contentsOf: series)
        return self.topRatedList
    }
    
    
}

