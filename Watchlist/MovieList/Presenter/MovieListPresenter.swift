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
    @Published var mediaList: [MovieListItemEntity]
    
    init(_ interactor: MovieListInteractor, section: MediaSection) {
        self.interactor = interactor
        self.section = section
        self.mediaList = [MovieListItemEntity]()
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
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate, let voteAverage = movie.voteAverage {
                self.mediaList.append(MovieListItemEntity(id: movie.id, title: movie.title, year: releaseDate, imgUrl: movie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .movie))
            }
        }
    }
    
    private func loadMostRecentMovies() async -> Void {
        
        let movies = await interactor.fetchNextMostRecentPageAsFullList()
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate, let voteAverage = movie.voteAverage {
                self.mediaList.append(MovieListItemEntity(id: movie.id, title: movie.title, year: releaseDate, imgUrl: movie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .movie ))
            }
        }
    }
    
    private func loadUpcomingMovies() async -> Void {
        
        let movies = await interactor.fetchNextUpcomingPageAsFullList()
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate, let voteAverage = movie.voteAverage {
                self.mediaList.append(MovieListItemEntity(id: movie.id, title: movie.title, year: releaseDate , imgUrl: movie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .movie))
            }
        }
    }
    
    private func loadAiringToday() async -> Void {
        
        let series = await interactor.fetcthAiringTodayPageAsFullList()
        series.forEach { (serie) in
            if let voteAverage = serie.voteAverage, let firstAirDate = serie.firstAirDate {
                self.mediaList.append(MovieListItemEntity(id: serie.id, title: serie.name, year: firstAirDate, imgUrl: serie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .tv))
            }
        }
    }
    
    private func loadOnTheAir() async -> Void {
        
        let series = await interactor.fetcthOnTheAirPageAsFullList()
        series.forEach { (serie) in
            if let voteAverage = serie.voteAverage, let firstAirDate = serie.firstAirDate {
                self.mediaList.append(MovieListItemEntity(id: serie.id, title: serie.name, year: firstAirDate, imgUrl: serie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .tv))
            }
        }
        
    }
    
    private func loadTopRated() async -> Void {
        let series = await interactor.fetcthTopRatedPageAsFullList()
        series.forEach { (serie) in
            if let voteAverage = serie.voteAverage, let firstAirDate = serie.firstAirDate {
                self.mediaList.append(MovieListItemEntity(id: serie.id, title: serie.name, year: firstAirDate, imgUrl: serie.getPosterUrl(), rating: voteAverage, genres: "", mediaType: .tv))
            }
        }
    }
    
}
