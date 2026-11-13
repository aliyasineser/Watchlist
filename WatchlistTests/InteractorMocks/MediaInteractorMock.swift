//
//  MovieListInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.09.2022.
//
// swiftlint:disable:all identifier_name
import Foundation
@testable import Watchlist

final class MediaInteractorMock: MediaInteractor {
    var error: Error?
    var requestedPages: [Int] = []

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

    func fetchNextPopularPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetchNextPopularPageAsFullListWasCalledOnce = true
        return fetchNextPopularPageAsFullListStub
    }

    func fetchNextMostRecentPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetchNextMostRecentPageAsFullListWasCalledOnce = true
        return fetchNextMostRecentPageAsFullListStub
    }

    func fetchNextUpcomingPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetchNextUpcomingPageAsFullListWasCalledOnce = true
        return fetchNextUpcomingPageAsFullListStub
    }

    func fetcthNextAiringTodayPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetcthAiringTodayPageAsFullListWasCalledOnce = true
        return fetcthAiringTodayPageAsFullListStub
    }

    func fetcthNextOnTheAirPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetcthOnTheAirPageAsFullListWasCalledOnce = true
        return fetcthOnTheAirPageAsFullListStub
    }

    func fetcthNextTopRatedPageAsFullList() async throws -> [Watchable] {
        if let error { throw error }
        fetcthTopRatedPageAsFullListWasCalledOnce = true
        return fetcthTopRatedPageAsFullListStub
    }
}
