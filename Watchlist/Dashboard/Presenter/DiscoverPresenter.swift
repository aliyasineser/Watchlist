//
//  DiscoverPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import SwiftUI

@MainActor
protocol DiscoverPresenter: ObservableObject {
    var interactor: MediaInteractor { get }
    var popularMovies: [Watchable] { get }
    var mostRecentMovies: [Watchable] { get }
    var upcomingMovies: [Watchable] { get }
    var airingTodaySeries: [Watchable] { get }
    var onTheAirSeries: [Watchable] { get }
    var topRatedSeries: [Watchable] { get }
    var isLoading: Bool { get }

    func fetchMedia()
}

final class DiscoverDefaultPresenter: DiscoverPresenter {

    private(set) var interactor: MediaInteractor
    @Published var popularMovies: [Watchable]
    @Published var mostRecentMovies: [Watchable]
    @Published var upcomingMovies: [Watchable]
    @Published var airingTodaySeries: [Watchable]
    @Published var onTheAirSeries: [Watchable]
    @Published var topRatedSeries: [Watchable]

    @Published var isLoading: Bool = false

    init(_ interactor: MediaInteractor) {
        self.interactor = interactor
        self.popularMovies = [Watchable]()
        self.mostRecentMovies = [Watchable]()
        self.upcomingMovies = [Watchable]()
        self.airingTodaySeries = [Watchable]()
        self.onTheAirSeries = [Watchable]()
        self.topRatedSeries = [Watchable]()

        self.isLoading = false
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

    private func loadPopularMovies() async {
        let movies = await interactor.fetchNextPopularPageAsFullList()
        mapToMovies(watchables: movies, container: &self.popularMovies)
    }

    private func loadMostRecentMovies() async {

        let movies = await interactor.fetchNextMostRecentPageAsFullList()
        mapToMovies(watchables: movies, container: &self.mostRecentMovies)
    }

    private func loadUpcomingMovies() async {

        let movies = await interactor.fetchNextUpcomingPageAsFullList()
        mapToMovies(watchables: movies, container: &self.upcomingMovies)
    }

    private func loadAiringToday() async {
        let series = await interactor.fetcthNextAiringTodayPageAsFullList()
        mapToSeries(watchables: series, container: &self.airingTodaySeries)
    }

    private func loadOnTheAir() async {
        let series = await interactor.fetcthNextOnTheAirPageAsFullList()
        mapToSeries(watchables: series, container: &self.onTheAirSeries)
    }

    private func loadTopRated() async {
        let series = await interactor.fetcthNextTopRatedPageAsFullList()
        mapToSeries(watchables: series, container: &self.topRatedSeries)
    }

    private func mapToMovies(watchables: [Watchable], container: inout [Watchable]) {
        watchables.compactMap { $0 as? Movie }
            .filter { $0.releaseDate != nil }
            .forEach { container.append($0) }
    }

    private func mapToSeries(watchables: [Watchable], container: inout [Watchable]) {
        watchables.compactMap { $0 as? TVSerie }
            .filter { $0.firstAirDate != nil }
            .forEach { container.append($0) }
    }
}
