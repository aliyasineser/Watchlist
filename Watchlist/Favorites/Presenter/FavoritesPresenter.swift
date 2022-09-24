//
//  FavoritesPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation
import Combine

class FavoritesPresenter: ObservableObject {
    private let interactor: FavoritesInteractor

    init(_ interactor: FavoritesInteractor) {
        self.interactor = interactor
    }
}
