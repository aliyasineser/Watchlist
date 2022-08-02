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
        let data = await movieService.fetchMovieCredits(id: id)
        if let movies = data {
            movies.crew.forEach { crewCredit in
                if let character = crewCredit.job {
                    artistMovies.append(MediaCreditEntity(id: crewCredit.id, creditId: crewCredit.creditID, title: crewCredit.originalName, role: character, image_path: crewCredit.getPosterUrl()))
                }
            }
            movies.cast.forEach { castCredit in
                if let character = castCredit.character {
                    artistMovies.append(MediaCreditEntity(id: castCredit.id, creditId: castCredit.creditID, title: castCredit.originalName, role: character, image_path: castCredit.getPosterUrl()))
                }
                
            }
            return artistMovies
        }
        return []
    }
    
    func fetchArtistTV(_ id: Int) async -> [MediaCreditEntity] {
        var artistShows: [MediaCreditEntity] = [MediaCreditEntity]()
        
        let data = await tvService.fetchTVCredits(id: id)
        if let shows = data {
            shows.crew.forEach { crewCredit in
                if let department = crewCredit.department {
                    artistShows.append(MediaCreditEntity(id: crewCredit.id, creditId: crewCredit.creditID, title: crewCredit.name, role: department.rawValue, image_path: crewCredit.getPosterUrl()))
                }
            }
            shows.cast.forEach { castCredit in
                if let character = castCredit.character {
                    artistShows.append(MediaCreditEntity(id: castCredit.id, creditId: castCredit.creditID, title: castCredit.name, role: character, image_path: castCredit.getPosterUrl()))
                }
            }
            return artistShows
        }
        return []
    }
}
