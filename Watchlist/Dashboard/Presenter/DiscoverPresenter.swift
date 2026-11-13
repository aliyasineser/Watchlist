//
//  DiscoverPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import Observation
import SwiftUI

@MainActor
protocol DiscoverPresenter: AnyObject {
    var interactor: MediaInteractor { get }
    var popularMovies: [Watchable] { get }
    var mostRecentMovies: [Watchable] { get }
    var upcomingMovies: [Watchable] { get }
    var airingTodaySeries: [Watchable] { get }
    var onTheAirSeries: [Watchable] { get }
    var topRatedSeries: [Watchable] { get }
    var isLoading: Bool { get }

    func fetchMedia() async
}

@MainActor
@Observable
final class DiscoverDefaultPresenter: DiscoverPresenter {

    private(set) var interactor: MediaInteractor
    var popularMovies: [Watchable]
    var mostRecentMovies: [Watchable]
    var upcomingMovies: [Watchable]
    var airingTodaySeries: [Watchable]
    var onTheAirSeries: [Watchable]
    var topRatedSeries: [Watchable]

    var fetchError: Error?

    var isLoading: Bool = false

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

    func fetchMedia() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        // Each section can succeed even if another section is unavailable.
        let loaders: [() async throws -> Void] = [
            loadPopularMovies, loadUpcomingMovies, loadMostRecentMovies,
            loadAiringToday, loadOnTheAir, loadTopRated
        ]
        for load in loaders {
            do {
                try Task.checkCancellation()
                try await load()
            } catch {
                guard !Task.isCancelled, !(error is CancellationError) else { return }
                fetchError = error
            }
        }
    }

    private func loadPopularMovies() async throws {
        let movies = try await interactor.fetchNextPopularPageAsFullList()
        try Task.checkCancellation()
        mapToMovies(watchables: movies, container: &popularMovies)
    }

    private func loadMostRecentMovies() async throws {
        let movies = try await interactor.fetchNextMostRecentPageAsFullList()
        try Task.checkCancellation()
        mapToMovies(watchables: movies, container: &self.mostRecentMovies)
    }

    private func loadUpcomingMovies() async throws {
        let movies = try await interactor.fetchNextUpcomingPageAsFullList()
        try Task.checkCancellation()
        mapToMovies(watchables: movies, container: &self.upcomingMovies)
    }

    private func loadAiringToday() async throws {
        let series = try await interactor.fetcthNextAiringTodayPageAsFullList()
        try Task.checkCancellation()
        mapToSeries(watchables: series, container: &self.airingTodaySeries)
    }

    private func loadOnTheAir() async throws {
        let series = try await interactor.fetcthNextOnTheAirPageAsFullList()
        try Task.checkCancellation()
        mapToSeries(watchables: series, container: &self.onTheAirSeries)
    }

    private func loadTopRated() async throws {
        let series = try await interactor.fetcthNextTopRatedPageAsFullList()
        try Task.checkCancellation()
        mapToSeries(watchables: series, container: &self.topRatedSeries)
    }

    private func mapToMovies(watchables: [Watchable], container: inout [Watchable]) {
        container = watchables.compactMap { $0 as? Movie }
            .filter { $0.releaseDate != nil }
    }

    private func mapToSeries(watchables: [Watchable], container: inout [Watchable]) {
        container = watchables.compactMap { $0 as? TVSerie }
            .filter { $0.firstAirDate != nil }
    }
}
