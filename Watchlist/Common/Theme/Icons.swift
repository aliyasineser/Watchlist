//
//  Icons.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 1.10.2022.
//

import Foundation

enum Icons: String, RawRepresentable {

    enum Favorite: String, RawRepresentable {
        case favorite = "heart.fill"
        case notFavorite = "heart"
    }

    case posterBackdrop = "film"

    case artistImageBackdrop = "person.fill"

    enum TabBar: String {
        case discover = "square.grid.2x2.fill"
        case artist = "person.crop.circle"
        case favorites = "star.circle.fill"
    }

    enum Buttons: String {
        case seeAll = "chevron.right"
    }
}
