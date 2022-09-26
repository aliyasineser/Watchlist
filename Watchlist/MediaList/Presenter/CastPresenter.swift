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
    @Published var artists: [CastEntity]

    var id: Int

    init(_ interactor: CastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.artists = [CastEntity]()
    }

    func loadArtists() {
        Task {
            let artists = await interactor.fetchCast(self.id)
            self.artists = artists.map { (artist) -> CastEntity in
                return CastEntity(
                    imageUrl: artist.imageUrl,
                    name: artist.name,
                    character: artist.character
                )
            }
        }
    }
}
