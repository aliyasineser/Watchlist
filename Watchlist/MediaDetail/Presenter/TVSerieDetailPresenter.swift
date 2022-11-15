//
//  TVSerieDetailPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation

@MainActor
protocol TVSerieDetailPresenter: ObservableObject {
    var id: Int { get }
    var interactor: TVSerieDetailInteractor { get }
    var media: TvDetail { get }
    var favoriteStorage: FavoriteStorage { get }

    func getMediaDetail()
}

final class TVSerieDetailDefaultPresenter: TVSerieDetailPresenter {
    private(set) var interactor: TVSerieDetailInteractor
    @Published var media: TvDetail = TvDetail.mock
    let id: Int
    var favoriteStorage: FavoriteStorage = FavoriteTVSerieStorage.shared

    init(interactor: TVSerieDetailInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
    }

    func getMediaDetail() {
        Task {
            let tvDetail = try await interactor.getMediaDetail(id)
            guard let detail = tvDetail as? TvDetail else { return }
            self.media = detail
        }
    }
}
