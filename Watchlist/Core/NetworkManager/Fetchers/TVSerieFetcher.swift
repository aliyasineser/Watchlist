//
//  TVSerieFetcher.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

enum TVSerieSection {
    case airingTodaySeries
    case onTheAirSeries
    case popular
}

class TVSerieFetcher: Fetchable {

    private var series: [Media] = []
    private var pageCounter: Int = 0
    private var section: TVSerieSection

    let tvSerieService: TVService

    init(for section: TVSerieSection, requestManager: RequestManager) {
        self.section = section
        self.tvSerieService = TVService(requestManager: requestManager)
    }

    func fetchSinglePage() async -> [Media] {
        pageCounter += 1
        var watchables: [Media] = []
        switch section {
        case .airingTodaySeries:
            watchables =  await tvSerieService.fetchMedia(request: TVRequest.getAiringTodaySeries(page: pageCounter))
        case .onTheAirSeries:
            watchables =  await tvSerieService.fetchMedia(request: TVRequest.getOnTheAirSeries(page: pageCounter))
        case .popular:
            watchables =  await tvSerieService.fetchMedia(request: TVRequest.getOnTheAirSeries(page: pageCounter))
        }
        return watchables
    }

    func fetchWithNextPage() async -> [Media] {
        let seriesPage = await fetchSinglePage()
        self.series.append(contentsOf: seriesPage)
        return self.series
    }

    func getFetched() -> [Media] {
        return series
    }
}
