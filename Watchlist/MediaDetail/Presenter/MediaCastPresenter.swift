//
//  MediaCastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

@MainActor
class MediaCastPresenter: ObservableObject {
    private let interactor: MediaCastInteractor
    @Published var artists: [CastMemberEntity]

    var id: Int

    init(_ interactor: MediaCastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.artists = [CastMemberEntity]()
    }

    public func loadArtists() {
        Task {
            self.artists = await interactor.fetchCast(self.id)
        }
    }
}
