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
    
    init(_ interactor: DiscoverInteractor) {
        self.interactor = interactor
        self.popularMovies = [DiscoverSectionItemEntity]()
        self.mostRecentMovies = [DiscoverSectionItemEntity]()
        self.upcomingMovies = [DiscoverSectionItemEntity]()
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
    
}
