//
//  ArtistDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

protocol ArtistDetailInteractor {
    func fetchArtist(_ id: Int) async -> ArtistDetailEntity?
    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity]
    func fetchArtistMovies(_ id: Int) async -> [MediaCreditEntity]
    func fetchArtistTV(_ id: Int) async -> [MediaCreditEntity]
}

final class DefaultArtistDetailInteractor: ArtistDetailInteractor {

    private let artistService: ArtistService = .shared

    func fetchArtist(_ id: Int) async -> ArtistDetailEntity? {
        let person = await artistService.fetchArtistDetail(id: id)
        if let person = person {
            let artistData = ArtistDetailEntity(
                id: person.id,
                name: person.name,
                biography: person.biography,
                birthday: person.birthday,
                deathday: person.deathday,
                asKnownAs: person.alsoKnownAs,
                placeOfBirth: person.placeOfBirth,
                imgUrl: person.getPosterUrl()
            )
            return artistData
        }
        return nil
    }

    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity] {
        var artistImages: [ArtistImageEntity] = [ArtistImageEntity]()
        let images = await artistService.fetchImages(id: id)
        for img in images {
            artistImages.append(ArtistImageEntity(
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

    func fetchArtistMovies(_ id: Int) async -> [MediaCreditEntity] {
        var artistMovies: [MediaCreditEntity] = [MediaCreditEntity]()
        let data = await artistService.fetchMovieCredits(id: id)
        if let movies = data {
            let allCast = movies.cast + movies.crew
            allCast.forEach { credit in
                artistMovies.append(MediaCreditEntity(
                    id: credit.id,
                    creditId: credit.creditID,
                    title: credit.getTitle(),
                    role: credit.job ?? credit.character ?? "Unknown",
                    imagePath: credit.getPosterUrl()
                )
                )
            }
        }
        return artistMovies
    }

    func fetchArtistTV(_ id: Int) async -> [MediaCreditEntity] {
        var artistShows: [MediaCreditEntity] = [MediaCreditEntity]()

        let data = await artistService.fetchTVCredits(id: id)
        if let shows = data {
            let allCast = shows.cast + shows.crew
            allCast.forEach { credit in
                artistShows.append(MediaCreditEntity(
                    id: credit.id,
                    creditId: credit.creditID,
                    title: credit.getTitle(),
                    role: credit.character ?? credit.job ??
                    credit.department?.rawValue ?? "Unknown",
                    imagePath: credit.getPosterUrl()
                )
                )
            }
        }
        return artistShows
    }
}

final class ArtistDetailInteractorStub: ArtistDetailInteractor {

    func fetchArtist(_ id: Int) async -> ArtistDetailEntity? {
        var mediaList: [ArtistDetailEntity] = []
        for _ in 0..<9 {
            mediaList.append(ArtistDetailEntity.mock)
        }
        return ArtistDetailEntity.mock
    }

    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity] {
        var imageList: [ArtistImageEntity] = []
        for _ in 0..<9 {
            imageList.append(ArtistImageEntity.mock)
        }
        return imageList
    }

    func fetchArtistMovies(_ id: Int) async -> [MediaCreditEntity] {
        var creditList: [MediaCreditEntity] = []
        for _ in 0..<9 {
            creditList.append(MediaCreditEntity.mock)
        }
        return creditList
    }

    func fetchArtistTV(_ id: Int) async -> [MediaCreditEntity] {
        var creditList: [MediaCreditEntity] = []
        for _ in 0..<9 {
            creditList.append(MediaCreditEntity.mock)
        }
        return creditList
    }
}
