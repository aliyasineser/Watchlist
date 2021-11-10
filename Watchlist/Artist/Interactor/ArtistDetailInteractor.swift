//
//  ArtistDetailInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation
import TMDBSwift

class ArtistDetailInteractor {
    
    func fetchArtist(_ id: Int, completion: @escaping (ArtistDetailEntity) -> Void) -> Void {
        PersonMDB.person_id(personID: id){
          data, personData in
          if let person = personData{
            let artistData = ArtistDetailEntity(id: person.id, name: person.name, biography: person.biography, birthday: person.birthday, deathday: person.deathday, as_known_as: person.also_known_as, place_of_birth: person.place_of_birth, imgUrl: person.getPosterUrl())
            completion(artistData)
          }
        }
        
        
    }
    
    func fetchArtistImages (_ id: Int, completion: @escaping ([ArtistImageEntity]) -> Void) -> Void {
        var artistImages: [ArtistImageEntity] = [ArtistImageEntity]()
        PersonMDB.images(personID: id) { client, data in
            if let images = data {
                for img in images {
                    artistImages.append(ArtistImageEntity(aspect_ratio: img.aspect_ratio ?? 0.8, file_path: img.file_path ?? "", height: img.height ?? 100, iso_639_1: img.iso_639_1 ?? "", vote_average: img.vote_average ?? 1, vote_count: img.vote_count ?? 1, width: img.width ?? 100))
                }
                completion(artistImages)
            }
        }
    }
    
    func fetchArtistMovies(_ id: Int, completion: @escaping ([MediaCreditEntity]) -> Void) -> Void {
        var artistMovies: [MediaCreditEntity] = [MediaCreditEntity]()
        
        PersonMDB.movie_credits(personID: id, language: "en") { clientReturn, data in
            if let movies = data {
                movies.crew.forEach { crewCredit in
                    if let character = crewCredit.job {
                        artistMovies.append(MediaCreditEntity(id: crewCredit.id, creditId: crewCredit.credit_id ?? "", title: crewCredit.title, role: character, image_path: crewCredit.poster_path ?? ""))
                    }
                }
                movies.cast.forEach { castCredit in
                    if let character = castCredit.character {
                        artistMovies.append(MediaCreditEntity(id: castCredit.id, creditId: castCredit.credit_id ?? "", title: castCredit.title, role: character, image_path: castCredit.poster_path ?? ""))
                    }
                    
                }
                completion(artistMovies)
            }
        }
    }
    
    func fetchArtistTV(_ id: Int, completion: @escaping ([MediaCreditEntity]) -> Void) -> Void {
        var artistShows: [MediaCreditEntity] = [MediaCreditEntity]()
        PersonMDB.tv_credits(personID: id, language: "en") { clientReturn, data in
            if let shows = data {
                shows.crew.forEach { crewCredit in
                    artistShows.append(MediaCreditEntity(id: crewCredit.id, creditId: crewCredit.credit_id ?? "", title: crewCredit.name, role: crewCredit.department, image_path: crewCredit.poster_path ?? ""))
                }
                shows.cast.forEach { castCredit in
                    artistShows.append(MediaCreditEntity(id: castCredit.id, creditId: castCredit.credit_id ?? "", title: castCredit.name, role: castCredit.character, image_path: castCredit.poster_path ?? ""))
                }
                completion(artistShows)
            }
        }
    }
}
