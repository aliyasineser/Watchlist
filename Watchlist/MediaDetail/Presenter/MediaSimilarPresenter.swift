//
//  SimilarMediaViewPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import Foundation
import Observation

@MainActor
protocol MediaSimilarPresenter: AnyObject {
    var id: Int { get }
    var interactor: MediaSimilarInteractor { get }
    var media: [Watchable] { get }

    func fetchSimilar() async
}

@MainActor
@Observable
final class MediaSimilarDefaultPresenter: MediaSimilarPresenter {
    private(set) var isLoading = false
    private(set) var hasMore = true
    var fetchError: Error?

    private(set) var interactor: MediaSimilarInteractor
    var media: [Watchable] = []
    let id: Int
    private var page: Int

    init(interactor: MediaSimilarInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
        self.page = 0
    }

    func fetchSimilar() async {
        guard hasMore, !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let nextPage = page + 1
            let similarPage = try await interactor.getSimilarMedia(id, page: nextPage)
            try Task.checkCancellation()
            page = nextPage
            hasMore = !similarPage.isEmpty
            var identifiers = Set(media.map(\.id))
            media.append(contentsOf: similarPage.filter { identifiers.insert($0.id).inserted })
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
