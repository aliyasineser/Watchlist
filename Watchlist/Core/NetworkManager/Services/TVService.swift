//
//  TVService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

final class TVService: MediaService {
    private let requestManager: RequestManager

    public static let shared = TVService()

    init(requestManager: RequestManager = DefaultRequestManager()) {
        self.requestManager = requestManager
    }

    func fetchMedia(request: NetworkRequest) async -> [Watchable] {
        do {
            let series: TVSerieResponse = try await requestManager.initRequest(with: request)
            return series.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchMediaDetails(id: Int) async -> MediaDetail? {
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

    func fetchMediaCredits(id: Int) async -> Credits? {
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
