//
//  CastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation

@MainActor
protocol CastPresenter: ObservableObject {

    var interactor: CastInteractor { get }
    var casts: [Cast] { get }
    var id: Int { get }

    func loadArtists()
}

final class CastDefaultPresenter: CastPresenter {

    var id: Int
    private(set) var interactor: CastInteractor
    @Published var casts: [Cast]
    @Published var error: Error?

    init(_ interactor: CastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.casts = [Cast]()
    }

    func loadArtists() {
        Task {
            self.casts = try await interactor.fetchCast(self.id)
        }
    }
}
