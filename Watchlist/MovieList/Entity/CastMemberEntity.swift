//
//  CastMemberEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 9.09.2021.
//

import Foundation


class CastMemberEntity: Identifiable {
    
    var id: Int
    var cast_id: Int?
    var character: String!
    var order: Int!
    var name: String
    var imageUrl: String
    
    init(id: Int, cast_id: Int?, character: String, order: Int? = nil, name: String, imageUrl: String) {
        self.cast_id = cast_id
        self.character = character
        self.order = order
        self.name = name
        self.imageUrl = imageUrl
        self.id = id
    }
    
}
