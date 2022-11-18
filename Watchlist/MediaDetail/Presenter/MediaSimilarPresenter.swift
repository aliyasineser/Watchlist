//
//  SimilarMediaViewPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

@MainActor
protocol MediaSimilarPresenter: ObservableObject {
    var id: Int { get }
    var interactor: MediaSimilarInteractor { get }
    var media: [Watchable] { get }

    func fetchSimilar()
}

final class MediaSimilarDefaultPresenter: MediaSimilarPresenter {
    private(set) var interactor: MediaSimilarInteractor
    @Published var media: [Watchable] = []
    let id: Int
    private var page: Int

    init(interactor: MediaSimilarInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
        self.page = 0
    }

    func fetchSimilar() {
        Task {
            page += 1
            let similarPage = try await interactor.getSimilarMedia(id, page: page)
            self.media.append(contentsOf: similarPage)
        }
    }
}
