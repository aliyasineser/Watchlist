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
    
    func fetchMedia(request: NetworkRequest) async throws -> [Watchable] {
        let series: TVSerieResponse = try await requestManager.initRequest(with: request)
        return series.results
    }

    func fetchMediaDetails(id: Int) async throws -> WatchableDetail? {
        let requestData = TVRequest.getSeriesDetail(id: id)
        let serie: TvDetail = try await
        requestManager.initRequest(with: requestData)
        return serie
    }

    func fetchReviews(id: Int, page: Int) async throws -> [Review] {
        let requestData = TVRequest.getSeriesReviews(id: id, page: page)
        let reviewResponse: MediaReviewResponse = try await requestManager.initRequest(with: requestData)
        return reviewResponse.results
    }

    func fetchSimilar(id: Int, page: Int) async throws -> [Watchable] {
        let requestData = TVRequest.getSimilarSeriesTo(id: id, page: page)
        let response: TVSerieSimilarResponse = try await requestManager.initRequest(with: requestData)
        return response.results
    }

    func fetchMediaCredits(id: Int) async throws -> Credits? {
        let requestData = TVRequest.getCredits(id: id)
        let credits: Credits = try await
        requestManager.initRequest(with: requestData)
        return credits
    }
}
