//
//  TVSerieDetailPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation

@MainActor
class TVSerieDetailPresenter: ObservableObject {
    let interactor: TVSerieDetailInteractor
    @Published var media: MediaDetailEntity = MediaDetailEntity()
    public let id: Int

    init(interactor: TVSerieDetailInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
    }

    func getMediaDetail() {
        Task {
            await getDetail(self.id)
        }
    }

    func getDetail(_ id: Int) async {
        let tvDetail = await interactor.getDetail(id)
        guard let detail = tvDetail as? TvDetail, let firstAirDate = detail.getReleaseDate() else { return }
        self.media = MediaDetailEntity(
            id: detail.id,
            title: detail.getTitle(),
            genres: nil,
            point: detail.voteAverage,
            language: detail.originalLanguage,
            date: firstAirDate,
            time: nil,
            summary: detail.getOverview(),
            imageUrl: detail.getPosterUrl(),
            mediaType: .tv
        )
    }
}
