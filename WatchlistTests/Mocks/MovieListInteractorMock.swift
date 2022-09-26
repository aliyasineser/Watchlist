//
//  MovieListInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.09.2022.
//
// swiftlint:disable:all identifier_name
import Foundation
@testable import Watchlist

final class MovieListInteractorMock: MediaInteractor {

    var fetchNextPopularPageAsFullListStub: [Watchable] = []
    var fetchNextMostRecentPageAsFullListStub: [Watchable] = []
    var fetchNextUpcomingPageAsFullListStub: [Watchable] = []
    var fetcthAiringTodayPageAsFullListStub: [Watchable] = []
    var fetcthOnTheAirPageAsFullListStub: [Watchable] = []
    var fetcthTopRatedPageAsFullListStub: [Watchable] = []

    var fetchNextPopularPageAsFullListWasCalledOnce: Bool = false
    var fetchNextMostRecentPageAsFullListWasCalledOnce: Bool = false
    var fetchNextUpcomingPageAsFullListWasCalledOnce: Bool = false
    var fetcthAiringTodayPageAsFullListWasCalledOnce: Bool = false
    var fetcthOnTheAirPageAsFullListWasCalledOnce: Bool = false
    var fetcthTopRatedPageAsFullListWasCalledOnce: Bool = false

    func fetchNextPopularPageAsFullList() async -> [Watchable] {
        fetchNextPopularPageAsFullListWasCalledOnce = true
        return fetchNextPopularPageAsFullListStub
    }

    func fetchNextMostRecentPageAsFullList() async -> [Watchable] {
        fetchNextMostRecentPageAsFullListWasCalledOnce = true
        return fetchNextMostRecentPageAsFullListStub
    }

    func fetchNextUpcomingPageAsFullList() async -> [Watchable] {
        fetchNextUpcomingPageAsFullListWasCalledOnce = true
        return fetchNextUpcomingPageAsFullListStub
    }

    func fetcthNextAiringTodayPageAsFullList() async -> [Watchable] {
        fetcthAiringTodayPageAsFullListWasCalledOnce = true
        return fetcthAiringTodayPageAsFullListStub
    }

    func fetcthNextOnTheAirPageAsFullList() async -> [Watchable] {
        fetcthOnTheAirPageAsFullListWasCalledOnce = true
        return fetcthOnTheAirPageAsFullListStub
    }

    func fetcthNextTopRatedPageAsFullList() async -> [Watchable] {
        fetcthTopRatedPageAsFullListWasCalledOnce = true
        return fetcthTopRatedPageAsFullListStub
    }
}
