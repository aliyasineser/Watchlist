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
    
}
