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

    func fetchMediaDetails(id: Int) async -> WatchableDetail? {
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

    func fetchReviews(id: Int, page: Int) async -> [Review] {
        let requestData = TVRequest.getSeriesReviews(id: id, page: page)
        do {
            let reviewResponse: MediaReviewResponse = try await requestManager.initRequest(with: requestData)
            return reviewResponse.results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }

    func fetchSimilar(id: Int, page: Int) async -> [Watchable] {
        let requestData = TVRequest.getSimilarSeriesTo(id: id, page: page)
        do {
            let response: TVSerieSimilarResponse = try await requestManager.initRequest(with: requestData)
            return response.results
        } catch {
            print(error.localizedDescription)
            return []
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
