//
//  ArtistPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import Observation

@MainActor
protocol ArtistPresenter: AnyObject {
    var interactor: ArtistInteractor { get }
    var artists: [Artist] { get }
    var isLoading: Bool { get }

    func loadArtists() async
}

@MainActor
@Observable
final class ArtistDefaultPresenter: ArtistPresenter {
    private(set) var interactor: ArtistInteractor
    var artists: [Artist]
    var fetchError: Error?
    var isLoading: Bool = false

    init(_ interactor: ArtistInteractor) {
        self.interactor = interactor
        self.artists = [Artist]()
    }

    func loadArtists() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        let artists = await interactor.fetchArtists()
        guard !Task.isCancelled else { return }
        self.artists.append(contentsOf: artists)
    }
}
