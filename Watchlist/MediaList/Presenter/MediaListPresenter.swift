//
//  MediaListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import SwiftUI

protocol MediaListPresenter: ObservableObject {

    var interactor: MediaInteractor { get }
    var section: MediaSection { get }
    var mediaList: [Watchable]  { get set }

    func fetchMedia()
}


final class MediaListDefaultPresenter: MediaListPresenter {

    var interactor: MediaInteractor
    var section: MediaSection
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
                self.mediaList = await interactor.fetchNextPopularPageAsFullList()
            case .mostRecentMovies:
                self.mediaList = await interactor.fetchNextMostRecentPageAsFullList()
            case .comingSoonMovies:
                self.mediaList = await interactor.fetchNextUpcomingPageAsFullList()
            case .airingTodaySeries:
                self.mediaList = await interactor.fetcthNextAiringTodayPageAsFullList()
            case .onTheAirSeries:
                self.mediaList = await interactor.fetcthNextOnTheAirPageAsFullList()
            case .topRatedSeries:
                self.mediaList = await interactor.fetcthNextTopRatedPageAsFullList()
            }
        }
    }
}
