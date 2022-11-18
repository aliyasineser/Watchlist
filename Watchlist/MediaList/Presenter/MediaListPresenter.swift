//
//  MediaListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

@MainActor
protocol MediaListPresenter: ObservableObject {

    var interactor: MediaInteractor { get }
    var section: MediaSection { get }
    var mediaList: [Watchable] { get set }

    func fetchMedia()
}

final class MediaListDefaultPresenter: MediaListPresenter {

    private(set) var interactor: MediaInteractor
    private(set) var section: MediaSection
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
                self.mediaList = try await interactor.fetchNextPopularPageAsFullList()
            case .mostRecentMovies:
                self.mediaList = try await interactor.fetchNextMostRecentPageAsFullList()
            case .comingSoonMovies:
                self.mediaList = try await interactor.fetchNextUpcomingPageAsFullList()
            case .airingTodaySeries:
                self.mediaList = try await interactor.fetcthNextAiringTodayPageAsFullList()
            case .onTheAirSeries:
                self.mediaList = try await interactor.fetcthNextOnTheAirPageAsFullList()
            case .topRatedSeries:
                self.mediaList = try await interactor.fetcthNextTopRatedPageAsFullList()
            }
        }
    }
}
