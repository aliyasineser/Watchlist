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
    var asKnownAs: [String]?
    var placeOfBirth: String?
    var imgUrl: String

    init(id: Int, name: String, biography: String?, birthday: String?,
         deathday: String?, asKnownAs: [String]?,
         placeOfBirth: String?, imgUrl: String) {
        self.id = id
        self.name = name
        self.biography = biography
        self.deathday = deathday
        self.asKnownAs = asKnownAs
        self.placeOfBirth = placeOfBirth
        self.imgUrl = APIConstants.defaultScheme + imgUrl
        self.birthday = birthday
    }
}
