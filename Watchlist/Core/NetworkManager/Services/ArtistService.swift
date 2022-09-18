//
//  ArtistService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

actor ArtistService {
    private let requestManager: RequestManager

    init(requestManager: RequestManager) {
        self.requestManager = requestManager
    }

    func fetchArtistDetail(id: Int) async -> ArtistDetail? {
        let requestData = ArtistRequest.getArtist(id: id)
        do {
            let artist: ArtistDetail = try await
            requestManager.initRequest(with: requestData)
            return artist
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchArtists(page: Int) async -> PopularArtists? {
        let requestData = ArtistRequest.getPopularArtists(page: page)
        do {
            let artists: PopularArtists = try await
            requestManager.initRequest(with: requestData)
            return artists
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchTVCredits(id: Int) async -> Credits? {
        let requestData = ArtistRequest.getTVCredits(id: id)
        do {
            let credits: Credits = try await
            requestManager.initRequest(with: requestData)
            return credits
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchMovieCredits(id: Int) async -> Credits? {
        let requestData = ArtistRequest.getMovieCredits(id: id)
        do {
            let credits: Credits = try await
            requestManager.initRequest(with: requestData)
            return credits
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func fetchImages(id: Int) async -> [Profile] {
        let requestData = ArtistRequest.getImages(id: id)
        do {
            let imageResponse: ArtistImageResponse = try await
            requestManager.initRequest(with: requestData)
            return imageResponse.profiles
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
