//
//  MediaCreditEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 10.11.2021.
//

import Foundation

struct MediaCreditEntity: Identifiable {

    var id: Int
    var creditId: String
    var title: String
    var role: String
    var imagePath: String

    init(id: Int, creditId: String, title: String, role: String, imagePath: String) {
        self.id = id
        self.creditId = creditId
        self.title = title
        self.role = role
        self.imagePath = imagePath
    }
}
