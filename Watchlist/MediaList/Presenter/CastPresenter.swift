//
//  CastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import Foundation
import Observation

@MainActor
protocol CastPresenter: AnyObject {

    var interactor: CastInteractor { get }
    var casts: [Cast] { get }
    var id: Int { get }

    func loadArtists() async
}

@MainActor
@Observable
final class CastDefaultPresenter: CastPresenter {

    var id: Int
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: CastInteractor
    var casts: [Cast]
    var error: Error?

    init(_ interactor: CastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.casts = [Cast]()
    }

    func loadArtists() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let cast = try await interactor.fetchCast(id)
            try Task.checkCancellation()
            casts = cast
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
