//
//  MediaCreditEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 10.11.2021.
//

import Foundation


import Foundation
import TMDBSwift

struct MediaCreditEntity: Identifiable {
    
    var id: Int
    var creditId: String
    var title: String
    var role: String
    var image_path: String
    
    init(id: Int, creditId: String, title: String, role: String, image_path: String) {
        self.id = id
        self.creditId = creditId
        self.title = title
        self.role = role
        self.image_path = image_path
    }
}
