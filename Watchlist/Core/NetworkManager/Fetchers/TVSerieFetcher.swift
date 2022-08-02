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
    
    private var series: [Watchable] = []
    private var pageCounter: Int = 0
    private var section: TVSerieSection
    
    let tvSerieService = TVService(requestManager: RequestManager())
    
    init(for section: TVSerieSection) {
        self.section = section
    }
    
    func fetchSinglePage() async -> [Watchable] {
        pageCounter += 1
        switch section {
        case .airingTodaySeries:
            return await tvSerieService.fetchAiringTodaySeries(page: pageCounter)
        case .onTheAirSeries:
            return await tvSerieService.fetchOnTheAirSeries(page: pageCounter)
        case .popular:
            return await tvSerieService.fetchPopularSeries(page: pageCounter)
        }
    }
    
    func fetchWithNextPage() async -> [Watchable] {
        let seriesPage = await fetchSinglePage()
        self.series.append(contentsOf: seriesPage)
        return self.series
    }
    
    func getFetched() -> [Watchable] {
        return series
    }
}
