//
//  ArtistService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

final class ArtistService {
    private let requestManager: RequestManager

    public static let shared = ArtistService()

    init(requestManager: RequestManager = DefaultRequestManager()) {
        self.requestManager = requestManager
    }

    func fetchArtistDetail(id: Int) async throws -> ArtistDetail? {
        let requestData = ArtistRequest.getArtist(id: id)
        let artist: ArtistDetail = try await
        requestManager.initRequest(with: requestData)
        return artist
    }

    func fetchArtists(page: Int) async throws -> PopularArtists? {
        let requestData = ArtistRequest.getPopularArtists(page: page)
        let artists: PopularArtists = try await
        requestManager.initRequest(with: requestData)
        return artists
    }

    func fetchTVCredits(id: Int) async throws -> Credits? {
        let requestData = ArtistRequest.getTVCredits(id: id)
        let credits: Credits = try await
        requestManager.initRequest(with: requestData)
        return credits
    }

    func fetchMovieCredits(id: Int) async throws -> Credits? {
        let requestData = ArtistRequest.getMovieCredits(id: id)
        let credits: Credits = try await
        requestManager.initRequest(with: requestData)
        return credits
    }

    func fetchImages(id: Int) async throws -> [Profile] {
        let requestData = ArtistRequest.getImages(id: id)
        let imageResponse: ArtistImageResponse = try await
        requestManager.initRequest(with: requestData)
        return imageResponse.profiles
    }
}
