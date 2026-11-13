//
//  TVSerieDetailPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation
import Observation

@MainActor
protocol TVSerieDetailPresenter: AnyObject {
    var id: Int { get }
    var interactor: TVSerieDetailInteractor { get }
    var media: TvDetail { get }
    var favoriteStorage: FavoriteStorage { get }

    func getMediaDetail() async
}

@MainActor
@Observable
final class TVSerieDetailDefaultPresenter: TVSerieDetailPresenter {
    private(set) var isLoading = false
    private(set) var hasLoaded = false
    var fetchError: Error?

    private(set) var interactor: TVSerieDetailInteractor
    var media: TvDetail = TvDetail.mock
    let id: Int
    let favoriteStorage: FavoriteStorage

    init(interactor: TVSerieDetailInteractor, id: Int, favoriteStorage: FavoriteStorage? = nil) {
        self.favoriteStorage = favoriteStorage ?? FavoriteTVSerieStorage.shared
        self.interactor = interactor
        self.id = id
    }

    func getMediaDetail() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let tvDetail = try await interactor.getMediaDetail(id)
            guard let detail = tvDetail as? TvDetail else { throw NetworkError.invalidServerResponse }
            try Task.checkCancellation()
            self.media = detail
            hasLoaded = true
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
