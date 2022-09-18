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

    var fetchNextPopularPageAsFullListStub: [Media] = []
    var fetchNextMostRecentPageAsFullListStub: [Media] = []
    var fetchNextUpcomingPageAsFullListStub: [Media] = []
    var fetcthAiringTodayPageAsFullListStub: [Media] = []
    var fetcthOnTheAirPageAsFullListStub: [Media] = []
    var fetcthTopRatedPageAsFullListStub: [Media] = []

    var fetchNextPopularPageAsFullListWasCalledOnce: Bool = false
    var fetchNextMostRecentPageAsFullListWasCalledOnce: Bool = false
    var fetchNextUpcomingPageAsFullListWasCalledOnce: Bool = false
    var fetcthAiringTodayPageAsFullListWasCalledOnce: Bool = false
    var fetcthOnTheAirPageAsFullListWasCalledOnce: Bool = false
    var fetcthTopRatedPageAsFullListWasCalledOnce: Bool = false

    func fetchNextPopularPageAsFullList() async -> [Media] {
        fetchNextPopularPageAsFullListWasCalledOnce = true
        return fetchNextPopularPageAsFullListStub
    }

    func fetchNextMostRecentPageAsFullList() async -> [Media] {
        fetchNextMostRecentPageAsFullListWasCalledOnce = true
        return fetchNextMostRecentPageAsFullListStub
    }

    func fetchNextUpcomingPageAsFullList() async -> [Media] {
        fetchNextUpcomingPageAsFullListWasCalledOnce = true
        return fetchNextUpcomingPageAsFullListStub
    }

    func fetcthAiringTodayPageAsFullList() async -> [Media] {
        fetcthAiringTodayPageAsFullListWasCalledOnce = true
        return fetcthAiringTodayPageAsFullListStub
    }

    func fetcthOnTheAirPageAsFullList() async -> [Media] {
        fetcthOnTheAirPageAsFullListWasCalledOnce = true
        return fetcthOnTheAirPageAsFullListStub
    }

    func fetcthTopRatedPageAsFullList() async -> [Media] {
        fetcthTopRatedPageAsFullListWasCalledOnce = true
        return fetcthTopRatedPageAsFullListStub
    }
}
