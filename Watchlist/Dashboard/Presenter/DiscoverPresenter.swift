//
//  DiscoverPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import SwiftUI

@MainActor
class DiscoverPresenter: ObservableObject {

    private let interactor: DiscoverInteractor
    @Published var popularMovies: [DiscoverSectionItemEntity]
    @Published var mostRecentMovies: [DiscoverSectionItemEntity]
    @Published var upcomingMovies: [DiscoverSectionItemEntity]
    @Published var airingTodaySeries: [DiscoverSectionItemEntity]
    @Published var onTheAirSeries: [DiscoverSectionItemEntity]
    @Published var topRatedSeries: [DiscoverSectionItemEntity]

    @Published var isLoading: Bool = false

    init(_ interactor: DiscoverInteractor) {
        self.interactor = interactor
        self.popularMovies = [DiscoverSectionItemEntity]()
        self.mostRecentMovies = [DiscoverSectionItemEntity]()
        self.upcomingMovies = [DiscoverSectionItemEntity]()
        self.airingTodaySeries = [DiscoverSectionItemEntity]()
        self.onTheAirSeries = [DiscoverSectionItemEntity]()
        self.topRatedSeries = [DiscoverSectionItemEntity]()

        self.isLoading = false
    }

    func loadPopularMovies() async {
        let movies = await interactor.fetchNextPopularPageAsFullList()
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate {
                self.popularMovies.append(DiscoverSectionItemEntity(id: movie.id, title: movie.getTitle(),
                                                                year: releaseDate, imgUrl: movie.getPosterUrl(),
                                                                genre: "", mediaType: .movie))
            }
        }
    }

    func loadMostRecentMovies() async {

        let movies = await interactor.fetchNextMostRecentPageAsFullList()
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate {
                self.mostRecentMovies.append(DiscoverSectionItemEntity(id: movie.id, title: movie.getTitle(),
                                                                   year: releaseDate, imgUrl: movie.getPosterUrl(),
                                                                   genre: "", mediaType: .movie))
            }
        }
    }

    func loadUpcomingMovies() async {

        let movies = await interactor.fetchNextUpcomingPageAsFullList()
        movies.forEach { (movie) in
            if let releaseDate = movie.releaseDate {
                self.upcomingMovies.append(DiscoverSectionItemEntity(id: movie.id, title: movie.getTitle(),
                                                                 year: releaseDate, imgUrl: movie.getPosterUrl(),
                                                                 genre: "", mediaType: .movie))
            }
        }
    }

    func loadAiringToday() async {
        let series = await interactor.fetcthAiringTodayPageAsFullList()
        series.forEach { (serie) in
            self.airingTodaySeries.append(DiscoverSectionItemEntity(id: serie.id, title: serie.name,
                                                                year: serie.firstAirDate, imgUrl: serie.getPosterUrl(),
                                                                genre: "", mediaType: .tv))
        }
    }

    func loadOnTheAir() async {
        let series = await interactor.fetcthOnTheAirPageAsFullList()
        series.forEach { (serie) in
            self.onTheAirSeries.append(DiscoverSectionItemEntity(id: serie.id, title: serie.name,
                                                                 year: serie.firstAirDate, imgUrl: serie.getPosterUrl(),
                                                                 genre: "", mediaType: .tv))
        }
    }

    func loadTopRated() async {
        let series = await interactor.fetcthTopRatedPageAsFullList()
        series.forEach { (serie) in
            self.topRatedSeries.append(DiscoverSectionItemEntity(id: serie.id, title: serie.name,
                                                                 year: serie.firstAirDate, imgUrl: serie.getPosterUrl(),
                                                                 genre: "", mediaType: .tv))
        }
    }

    func fetchMedia() {
        isLoading = false
        Task {
            await loadPopularMovies()
            await loadUpcomingMovies()
            await loadMostRecentMovies()
            await loadAiringToday()
            await loadOnTheAir()
            await loadTopRated()
        }
        isLoading = true
    }
}
