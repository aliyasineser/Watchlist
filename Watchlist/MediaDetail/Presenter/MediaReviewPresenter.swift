//
//  MediaReviewPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation
import Observation

@MainActor
protocol MediaReviewPresenter: AnyObject {
    var id: Int { get }
    var interactor: MediaReviewInteractor { get }
    var reviews: [Review] { get }

    func fetchReviews() async
}

@MainActor
@Observable
final class MediaReviewDefaultPresenter: MediaReviewPresenter {
    private(set) var isLoading = false
    var fetchError: Error?

    private(set) var interactor: MediaReviewInteractor
    var reviews: [Review] = []
    let id: Int
    private var page: Int

    init(interactor: MediaReviewInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
        self.page = 0
    }

    func fetchReviews() async {
        guard !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let nextPage = page + 1
            let reviewPage = try await interactor.getMovieReview(id, page: nextPage)
            try Task.checkCancellation()
            page = nextPage
            self.reviews.append(contentsOf: reviewPage)
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
