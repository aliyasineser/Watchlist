//
//  MediaListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import SwiftUI

@MainActor
class MediaListPresenter: ObservableObject {

    private let interactor: MediaInteractor
    private let section: MediaSection
    @Published var mediaList: [Watchable]

    init(_ interactor: MediaInteractor, section: MediaSection) {
        self.interactor = interactor
        self.section = section
        self.mediaList = [Watchable]()
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
        self.mediaList = await interactor.fetchNextPopularPageAsFullList()
    }

    private func loadMostRecentMovies() async {
        self.mediaList = await interactor.fetchNextMostRecentPageAsFullList()
    }

    private func loadUpcomingMovies() async {
        self.mediaList = await interactor.fetchNextUpcomingPageAsFullList()
    }

    private func loadAiringToday() async {
        self.mediaList = await interactor.fetcthNextAiringTodayPageAsFullList()
    }

    private func loadOnTheAir() async {
        self.mediaList = await interactor.fetcthNextOnTheAirPageAsFullList()
    }

    private func loadTopRated() async {
        self.mediaList = await interactor.fetcthNextTopRatedPageAsFullList()
    }

}
