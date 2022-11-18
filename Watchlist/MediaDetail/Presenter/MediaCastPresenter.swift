//
//  MediaCastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
protocol MediaCastPresenter: ObservableObject {
    var id: Int { get }
    var interactor: MediaCastInteractor { get }
    var artists: [Cast] { get }

    func loadArtists()
}

final class MediaCastDefaultPresenter: MediaCastPresenter {
    private(set) var interactor: MediaCastInteractor
    @Published var artists: [Cast]
    var id: Int

    init(_ interactor: MediaCastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.artists = [Cast]()
    }

    func loadArtists() {
        Task {
            self.artists = try await interactor.fetchCast(self.id)
        }
    }
}
