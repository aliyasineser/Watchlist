//
//  ArtistDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

protocol ArtistDetailInteractor {
    func fetchArtist(_ id: Int) async -> ArtistDetail?
    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity]
    func fetchArtistMovies(_ id: Int) async -> [Cast]
    func fetchArtistTV(_ id: Int) async -> [Cast]
}

final class DefaultArtistDetailInteractor: ArtistDetailInteractor {

    private let artistService: ArtistService = .shared

    func fetchArtist(_ id: Int) async -> ArtistDetail? {
        let person = await artistService.fetchArtistDetail(id: id)
        guard let person else { return nil }
        return person
    }

    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity] {
        var artistImages: [ArtistImageEntity] = [ArtistImageEntity]()
        let images = await artistService.fetchImages(id: id)
        for img in images {
            artistImages.append(
                ArtistImageEntity(
                    aspectRatio: img.aspectRatio,
                    filePath: img.filePath,
                    height: img.height,
                    iso_639_1: img.iso639_1 ?? APIConstants.language,
                    voteAverage: img.voteAverage,
                    voteCount: img.voteCount,
                    width: img.width
                )
            )
        }
        return artistImages
    }

    func fetchArtistMovies(_ id: Int) async -> [Cast] {
        var artistMovies: [Cast] = [Cast]()
        let data = await artistService.fetchMovieCredits(id: id)
        if let movies = data {
            let allCast = movies.cast + movies.crew
            artistMovies.append(contentsOf: allCast)
        }
        return artistMovies
    }

    func fetchArtistTV(_ id: Int) async -> [Cast] {
        var artistShows: [Cast] = [Cast]()

        let data = await artistService.fetchTVCredits(id: id)
        if let shows = data {
            let allCast = shows.cast + shows.crew
            artistShows.append(contentsOf: allCast)
        }
        return artistShows
    }
}

final class ArtistDetailInteractorStub: ArtistDetailInteractor {

    func fetchArtist(_ id: Int) async -> ArtistDetail? {
        var mediaList: [ArtistDetail] = []
        for _ in 0..<9 {
            mediaList.append(ArtistDetail.mock)
        }
        return ArtistDetail.mock
    }

    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity] {
        var imageList: [ArtistImageEntity] = []
        for _ in 0..<9 {
            imageList.append(ArtistImageEntity.mock)
        }
        return imageList
    }

    func fetchArtistMovies(_ id: Int) async -> [Cast] {
        var creditList: [Cast] = []
        for _ in 0..<9 {
            creditList.append(Cast.mock)
        }
        return creditList
    }

    func fetchArtistTV(_ id: Int) async -> [Cast] {
        var creditList: [Cast] = []
        for _ in 0..<9 {
            creditList.append(Cast.mock)
        }
        return creditList
    }
}
