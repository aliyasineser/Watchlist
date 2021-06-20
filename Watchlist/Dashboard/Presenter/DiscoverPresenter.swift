//
//  DiscoverPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import TMDBSwift

class DiscoverPresenter: ObservableObject {
    
    private let interactor: DiscoverInteractor
    @Published var popularMovies: [DiscoverSectionItemEntity]
    @Published var mostRecentMovies: [DiscoverSectionItemEntity]
    @Published var upcomingMovies: [DiscoverSectionItemEntity]
    @Published var airingTodaySeries: [DiscoverSectionItemEntity]
    @Published var onTheAirSeries: [DiscoverSectionItemEntity]
    @Published var topRatedSeries: [DiscoverSectionItemEntity]
    
    init(_ interactor: DiscoverInteractor) {
        self.interactor = interactor
        self.popularMovies = [DiscoverSectionItemEntity]()
        self.mostRecentMovies = [DiscoverSectionItemEntity]()
        self.upcomingMovies = [DiscoverSectionItemEntity]()
        self.airingTodaySeries = [DiscoverSectionItemEntity]()
        self.onTheAirSeries = [DiscoverSectionItemEntity]()
        self.topRatedSeries = [DiscoverSectionItemEntity]()
    }
    
    
    func loadPopularMovies() -> Void {
        interactor.fetchNextPopularPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date {
                    self.popularMovies.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl()))
                }
            }
        })
    }
    
    func loadMostRecentMovies() -> Void {
        interactor.fetchNextMostRecentPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date {
                    self.mostRecentMovies.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl()))
                }
            }
        })
    }
    
    func loadUpcomingMovies() -> Void {
        interactor.fetchNextUpcomingPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date {
                    self.upcomingMovies.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl()))
                }
            }
        })
    }
    
    func loadAiringToday() -> Void {
        interactor.fetcthAiringTodayPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date {
                    self.airingTodaySeries.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl()))
                }
            }
        })
    }
    
    func loadOnTheAir() -> Void {
        interactor.fetcthOnTheAirPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date {
                    self.onTheAirSeries.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl()))
                }
            }
        })
    }
    
    func loadTopRated() -> Void {
        interactor.fetcthTopRatedPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date {
                    self.topRatedSeries.append(DiscoverSectionItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl()))
                }
            }
        })
    }
    
}
