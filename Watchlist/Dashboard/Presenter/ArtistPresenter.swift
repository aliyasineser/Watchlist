//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
protocol ArtistPresenter: ObservableObject {
    var interactor: ArtistInteractor { get }
    var artists: [Artist] { get }
    var isLoading: Bool { get }

    func loadArtists()
}

final class ArtistDefaultPresenter: ArtistPresenter {
    private(set) var interactor: ArtistInteractor
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
