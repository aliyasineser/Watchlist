//
//  MediaCastPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation
import Observation

@MainActor
protocol MediaCastPresenter: AnyObject {
    var id: Int { get }
    var interactor: MediaCastInteractor { get }
    var artists: [Cast] { get }

    func loadArtists() async
}

@MainActor
@Observable
final class MediaCastDefaultPresenter: MediaCastPresenter {
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: MediaCastInteractor
    var artists: [Cast]
    var id: Int

    init(_ interactor: MediaCastInteractor, id: Int) {
        self.id = id
        self.interactor = interactor
        self.artists = [Cast]()
    }

    func loadArtists() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let cast = try await interactor.fetchCast(id)
            try Task.checkCancellation()
            artists = cast
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
