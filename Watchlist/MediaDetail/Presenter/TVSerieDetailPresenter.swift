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
    @Published var media: TvDetail = TvDetail.mock
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
        guard let detail = tvDetail as? TvDetail else { return }
        self.media = detail
    }
}
