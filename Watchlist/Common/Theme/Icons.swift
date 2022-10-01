//
//  Icons.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 1.10.2022.
//

import Foundation

enum Icons: String, RawRepresentable {
    case favoriteOn = "heart.fill"
    case favoriteOff = "heart"

    case posterBackdrop = "film"

    case artistImageBackdrop = "person.fill"

    public enum TabBar: String {
        case discover = "square.grid.2x2.fill"
        case artist = "person.crop.circle"
        case favorites = "star.circle.fill"
    }

    case seeAllButton = "chevron.right"
}
