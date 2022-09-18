//
//  CastMemberEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 9.09.2021.
//

import Foundation

class CastMemberEntity: Identifiable {

    var id: Int
    var castId: Int?
    var character: String!
    var order: Int!
    var name: String
    var imageUrl: String

    init(id: Int, castId: Int?, character: String, order: Int? = nil, name: String, imageUrl: String) {
        self.castId = castId
        self.character = character
        self.order = order
        self.name = name
        self.imageUrl = imageUrl
        self.id = id
    }
}

extension CastMemberEntity {
    static let mock = CastMemberEntity(id: 1,
                                       castId: 1,
                                       character: "Character",
                                       name: "Cast Name",
                                       imageUrl: "Image Url"
    )
}
