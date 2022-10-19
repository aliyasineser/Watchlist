//
//  MediaReviewPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation

@MainActor
protocol MediaReviewPresenter: ObservableObject {
    var id: Int { get }
    var interactor: MediaReviewInteractor { get }
    var reviews: [Review] { get }

    func fetchReviews()
}

final class MediaReviewDefaultPresenter: MediaReviewPresenter {
    private(set) var interactor: MediaReviewInteractor
    @Published var reviews: [Review] = []
    let id: Int
    private var page: Int

    init(interactor: MediaReviewInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
        self.page = 0
    }

    func fetchReviews() {
        Task {
            page += 1
            let reviewPage = await interactor.getMovieReview(id, page: page)
            self.reviews.append(contentsOf: reviewPage)
        }
    }
}
