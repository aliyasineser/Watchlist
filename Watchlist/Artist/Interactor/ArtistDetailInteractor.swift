//
//  ArtistDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

class ArtistDetailInteractor {
    
    let movieService = MovieService(requestManager: RequestManager())
    let tvService = TVService(requestManager: RequestManager())
    let artistService = ArtistService(requestManager: RequestManager())
    
    
    func fetchArtist(_ id: Int) async -> ArtistDetailEntity? {
        let person = await artistService.fetchArtistDetail(id: id)
        if let person = person{
            let artistData = ArtistDetailEntity(id: person.id, name: person.name, biography: person.biography, birthday: person.birthday, deathday: person.deathday, as_known_as: person.alsoKnownAs, place_of_birth: person.placeOfBirth, imgUrl: person.getPosterUrl())
            return artistData
        }
        return nil
    }
    
    func fetchArtistImages (_ id: Int) async -> [ArtistImageEntity] {
        var artistImages: [ArtistImageEntity] = [ArtistImageEntity]()
        let images = await artistService.fetchImages(id: id)
        for img in images {
            artistImages.append(ArtistImageEntity(aspect_ratio: img.aspectRatio, file_path: img.filePath, height: img.height, iso_639_1: img.iso639_1 ?? APIConstants.language, vote_average: img.voteAverage, vote_count: img.voteCount, width: img.width))
        }
        return artistImages
    }
    
    func fetchArtistMovies(_ id: Int) async -> [MediaCreditEntity] {
        var artistMovies: [MediaCreditEntity] = [MediaCreditEntity]()
        let data = await artistService.fetchMovieCredits(id: id)
        if let movies = data {
            let allCast = movies.cast + movies.crew
            allCast.forEach { credit in
                artistMovies.append(MediaCreditEntity(id: credit.id, creditId: credit.creditID, title: credit.getTitle(), role: credit.job ?? credit.character ?? "Unknown", image_path: credit.getPosterUrl()))
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
                artistShows.append(MediaCreditEntity(id: credit.id, creditId: credit.creditID, title: credit.getTitle(), role: credit.character ?? credit.department?.rawValue ?? "Unknown", image_path: credit.getPosterUrl()))
            }
        }
        return artistShows
    }
}
