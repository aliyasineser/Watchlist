//
//  TVService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor TVService {
    private let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func fetchPopularSeries(page: Int) async -> [TVSerie] {
        let requestData = TVRequest.getPopularSeries(page: page)
        do {
            let series: TVSerieResponse = try await
            requestManager.initRequest(with: requestData)
            return series.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchOnTheAirSeries(page: Int) async -> [TVSerie] {
        let requestData = TVRequest.getOnTheAirSeries(page: page)
        do {
            let series: TVSerieResponse = try await
            requestManager.initRequest(with: requestData)
            return series.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchAiringTodaySeries(page: Int) async -> [TVSerie] {
        let requestData = TVRequest.getAiringTodaySeries(page: page)
        do {
            let series: TVSerieResponse = try await
            requestManager.initRequest(with: requestData)
            return series.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchTVDetails(id: Int) async -> TvDetail? {
        let requestData = TVRequest.getSeriesDetail(id: id)
        do {
            let serie: TvDetail = try await
            requestManager.initRequest(with: requestData)
            return serie
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func fetchTVCredits(id: Int) async -> Credits? {
        let requestData = TVRequest.getCredits(id: id)
        do {
            let credits: Credits = try await
            requestManager.initRequest(with: requestData)
            return credits
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}


