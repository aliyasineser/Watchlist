//
//  MovieListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import SwiftUI

@MainActor
class MovieListPresenter {
    
    private let interactor: MovieListInteractor
    private let section: MediaSection
    @Published var mediaList: [Media]
    
    init(_ interactor: MovieListInteractor, section: MediaSection) {
        self.interactor = interactor
        self.section = section
        self.mediaList = [Media]()
    }
    
    func fetchMedia() -> Void {
        Task {
            switch self.section {
            case .popularMovies:
                await loadPopularMovies()
            case .mostRecentMovies:
                await loadMostRecentMovies()
            case .comingSoonMovies:
                await loadUpcomingMovies()
            case .airingTodaySeries:
                await loadAiringToday()
            case .onTheAirSeries:
                await loadOnTheAir()
            case .topRatedSeries:
                await loadTopRated()
            }
        }
    }
    
    private func loadPopularMovies() async -> Void {
        let movies = await interactor.fetchNextPopularPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }
    
    private func loadMostRecentMovies() async -> Void {
        
        let movies = await interactor.fetchNextMostRecentPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }
    
    private func loadUpcomingMovies() async -> Void {
        
        let movies = await interactor.fetchNextUpcomingPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }
    
    private func loadAiringToday() async -> Void {
        
        let series = await interactor.fetcthAiringTodayPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }
    
    private func loadOnTheAir() async -> Void {
        
        let series = await interactor.fetcthOnTheAirPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }
    
    private func loadTopRated() async -> Void {
        let series = await interactor.fetcthTopRatedPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }
    
}
