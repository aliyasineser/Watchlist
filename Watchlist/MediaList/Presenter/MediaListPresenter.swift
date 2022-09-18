//
//  MediaListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import SwiftUI

@MainActor
class MediaListPresenter {

    private let interactor: MediaInteractor
    private let section: MediaSection
    @Published var mediaList: [Media]

    init(_ interactor: MediaInteractor, section: MediaSection) {
        self.interactor = interactor
        self.section = section
        self.mediaList = [Media]()
    }

    func fetchMedia() {
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

    private func loadPopularMovies() async {
        let movies = await interactor.fetchNextPopularPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }

    private func loadMostRecentMovies() async {
        let movies = await interactor.fetchNextMostRecentPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }

    private func loadUpcomingMovies() async {
        let movies = await interactor.fetchNextUpcomingPageAsFullList()
        self.mediaList.append(contentsOf: movies)
    }

    private func loadAiringToday() async {

        let series = await interactor.fetcthAiringTodayPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }

    private func loadOnTheAir() async {
        let series = await interactor.fetcthOnTheAirPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }

    private func loadTopRated() async {
        let series = await interactor.fetcthTopRatedPageAsFullList()
        self.mediaList.append(contentsOf: series)
    }

}
