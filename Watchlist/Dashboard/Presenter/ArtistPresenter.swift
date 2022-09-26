//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
class ArtistPresenter: ObservableObject {
    private let interactor: ArtistInteractor
    @Published var artists: [Artist]
    @Published var isLoading: Bool = false

    init(_ interactor: ArtistInteractor) {
        self.interactor = interactor
        self.artists = [Artist]()
    }

    func loadArtists() {
        Task {
            isLoading = true
            let artists = await interactor.fetchArtists()
            self.artists.append(contentsOf: artists)
            isLoading = false
        }
    }
}
