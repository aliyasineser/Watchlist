//
//  MovieListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import TMDBSwift

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
        switch self.section {
        case .popularMovies:
            loadPopularMovies()
        case .mostRecentMovies:
            loadMostRecentMovies()
        case .comingSoonMovies:
            loadUpcomingMovies()
        case .airingTodaySeries:
            loadAiringToday()
        case .onTheAirSeries:
            loadOnTheAir()
        case .topRatedSeries:
            loadTopRated()
        }
    }
    
    private func loadPopularMovies() -> Void {
        interactor.fetchNextPopularPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date, let rating = movie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl(), rating: rating, genres: movie.getGenresAsString() ))
                }
            }
        })
    }
    
    private func loadMostRecentMovies() -> Void {
        interactor.fetchNextMostRecentPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date, let rating = movie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl(), rating: rating, genres: movie.getGenresAsString() ))
                }
            }
        })
    }
    
    private func loadUpcomingMovies() -> Void {
        interactor.fetchNextUpcomingPageAsFullList(updater: { (movies) in
            movies.forEach { (movie) in
                if let id = movie.id, let title = movie.title, let releaseDate = movie.release_date, let rating = movie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: movie.getPosterUrl(), rating: rating, genres: movie.getGenresAsString()))
                }
            }
        })
    }
    
    private func loadAiringToday() -> Void {
        interactor.fetcthAiringTodayPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date, let rating = serie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl(), rating: rating, genres: serie.getGenresAsString()))
                }
            }
        })
    }
    
    private func loadOnTheAir() -> Void {
        interactor.fetcthOnTheAirPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date, let rating = serie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl(), rating: rating, genres: serie.getGenresAsString()))
                }
            }
        })
    }
    
    private func loadTopRated() -> Void {
        interactor.fetcthTopRatedPageAsFullList(updater: { (series) in
            series.forEach { (serie) in
                if let id = serie.id, let title = serie.name, let releaseDate = serie.first_air_date, let rating = serie.vote_average {
                    self.mediaList.append(MovieListItemEntity(id: id, title: title, year: releaseDate, imgUrl: serie.getPosterUrl(), rating: rating, genres: serie.getGenresAsString()))
                }
            }
        })
    }
    
}
