//
//  CastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

@MainActor
class CastPresenter: ObservableObject {

    private let interactor: CastInteractor
    @Published var casts: [Cast]

    var id: Int

    init(_ interactor: CastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.casts = [Cast]()
    }

    func loadArtists() {
        Task {
            self.casts = await interactor.fetchCast(self.id)
        }
    }
}
