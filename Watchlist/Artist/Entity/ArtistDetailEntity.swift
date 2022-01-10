//
//  ArtistDetailEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import Foundation

struct ArtistDetailEntity {
    var id: Int
    var name: String
    var biography: String?
    var birthday: String?
    var deathday: String?
    var as_known_as: [String]?
    var place_of_birth: String?
    var imgUrl: String
    
    init(id: Int, name: String, biography: String?, birthday: String?, deathday: String?, as_known_as: [String]?, place_of_birth: String?, imgUrl: String) {
        self.id = id
        self.name = name
        self.biography = biography
        self.deathday = deathday
        self.as_known_as = as_known_as
        self.place_of_birth = place_of_birth
        self.imgUrl = imgUrl
        self.birthday = birthday
        
    }
}
