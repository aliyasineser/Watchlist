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

    func getMediaDetail()
    func getDetail(_ id: Int) async
}

final class TVSerieDetailDefaultPresenter: TVSerieDetailPresenter {
    private(set) var interactor: TVSerieDetailInteractor
    @Published var media: TvDetail = TvDetail.mock
    let id: Int

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
