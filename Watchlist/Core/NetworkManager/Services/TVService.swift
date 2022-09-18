//
//  TVService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor TVService {
    private let requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func fetchSeries(request: NetworkRequest) async -> [TVSerie] {
        do {
            let series: TVSerieResponse = try await
            requestManager.initRequest(with: request)
            return series.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchTVDetails(id: Int) async -> MediaDetail? {
        let requestData = TVRequest.getSeriesDetail(id: id)
        do {
            let serie: TvDetail = try await
            requestManager.initRequest(with: requestData)
            return WatchableToMediaMapper.convertDetail(from: serie, type: .tv)
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
