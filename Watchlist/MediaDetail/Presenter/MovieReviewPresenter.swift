//
//  MovieReviewPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

@MainActor
protocol MovieReviewPresenter: ObservableObject {
    var id: Int { get }
    var interactor: MovieReviewInteractor { get }
    var reviews: [Review] { get }

    func fetchReviews()
}

final class MovieReviewDefaultPresenter: MovieReviewPresenter {
    private(set) var interactor: MovieReviewInteractor
    @Published var reviews: [Review] = []
    let id: Int
    private var page: Int

    init(interactor: MovieReviewInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
        self.page = 0
    }

    func fetchReviews() {
        Task {
            page += 1
            self.reviews = await interactor.getMovieReview(id, page: page)
        }
    }
}
