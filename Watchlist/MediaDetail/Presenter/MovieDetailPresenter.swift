//
//  MediaDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation
import Observation

@MainActor
protocol MovieDetailPresenter: AnyObject {
    var id: Int { get }
    var interactor: MovieDetailInteractor { get }
    var media: MovieDetail { get }
    var favoriteStorage: FavoriteStorage { get }

    func getMediaDetail() async
}

@MainActor
@Observable
final class MovieDetailDefaultPresenter: MovieDetailPresenter {
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: MovieDetailInteractor
    var media: MovieDetail = MovieDetail.mock
    let id: Int
    let favoriteStorage: FavoriteStorage

    init(interactor: MovieDetailInteractor, id: Int, favoriteStorage: FavoriteStorage = FavoriteMovieStorage.shared) {
        self.favoriteStorage = favoriteStorage
        self.interactor = interactor
        self.id = id
    }

    func getMediaDetail() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            guard let movieDetail = try await interactor.getMovieDetail(id) else { return }
            guard let detail = movieDetail as? MovieDetail else { return }
            try Task.checkCancellation()
            self.media = detail
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
