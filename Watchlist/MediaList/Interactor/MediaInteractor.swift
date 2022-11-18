//
//  MediaInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation

protocol MediaInteractor {
    func fetchNextPopularPageAsFullList() async throws -> [Watchable]
    func fetchNextMostRecentPageAsFullList() async throws -> [Watchable]
    func fetchNextUpcomingPageAsFullList() async throws -> [Watchable]
    func fetcthNextAiringTodayPageAsFullList() async throws -> [Watchable]
    func fetcthNextOnTheAirPageAsFullList() async throws -> [Watchable]
    func fetcthNextTopRatedPageAsFullList() async throws -> [Watchable]
}

final class DefaultMediaInteractor: MediaInteractor {

    let popularMoviesFetcher: Fetchable = MediaFetcher(
        strategy: PopularMoviesFetchStrategy(),
        service: MovieService.shared
    )

    let comingSoonMoviesFetcher: Fetchable = MediaFetcher(
        strategy: UpcomingMoviesFetchStrategy(),
        service: MovieService.shared
    )

    let mostRecentMoviesFetcher: Fetchable = MediaFetcher(
        strategy: NowPlayingMoviesFetchStrategy(),
        service: MovieService.shared
    )

    let popularSeriesFetcher: Fetchable = MediaFetcher(
        strategy: PopularSeriesFetchStrategy(),
        service: TVService.shared
    )

    let airingTodaySeriesFetcher: Fetchable = MediaFetcher(
        strategy: AiringTodaySeriesFetchStrategy(),
        service: TVService.shared
    )

    let onTheAirSeriesFetcher: Fetchable = MediaFetcher(
        strategy: OnTheAirSeriesFetchStrategy(),
        service: TVService.shared
    )

    func fetchNextPopularPageAsFullList() async throws -> [Watchable] {
        return try await popularMoviesFetcher.fetchWithNextPage()
    }

    func fetchNextMostRecentPageAsFullList() async throws -> [Watchable] {
        return try await mostRecentMoviesFetcher.fetchWithNextPage()
    }

    func fetchNextUpcomingPageAsFullList() async throws -> [Watchable] {
        return try await comingSoonMoviesFetcher.fetchWithNextPage()
    }

    func fetcthNextAiringTodayPageAsFullList() async throws -> [Watchable] {
        return try await airingTodaySeriesFetcher.fetchWithNextPage()
    }

    func fetcthNextOnTheAirPageAsFullList() async throws -> [Watchable] {
        return try await onTheAirSeriesFetcher.fetchWithNextPage()
    }

    func fetcthNextTopRatedPageAsFullList() async throws -> [Watchable] {
        return try await popularSeriesFetcher.fetchWithNextPage()
    }

}

final class MediaInteractorStub: MediaInteractor {
    private func getMediaList() -> [Watchable] {
        var mediaList: [Watchable] = []
        for _ in 0..<9 {
            mediaList.append(Movie.mock)
        }
        return mediaList
    }

    func fetchNextPopularPageAsFullList() async throws -> [Watchable] { getMediaList() }
    func fetchNextMostRecentPageAsFullList() async throws -> [Watchable] { getMediaList() }
    func fetchNextUpcomingPageAsFullList() async throws -> [Watchable] { getMediaList() }
    func fetcthNextAiringTodayPageAsFullList() async throws -> [Watchable] { getMediaList() }
    func fetcthNextOnTheAirPageAsFullList() async throws -> [Watchable] { getMediaList() }
    func fetcthNextTopRatedPageAsFullList() async throws -> [Watchable] { getMediaList() }
}
