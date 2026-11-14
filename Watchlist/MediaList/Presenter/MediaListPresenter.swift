//
//  MediaListPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import Foundation
import Observation

@MainActor
protocol MediaListPresenter: AnyObject {

    var interactor: MediaInteractor { get }
    var section: MediaSection { get }
    var mediaList: [Watchable] { get set }

    func fetchMedia() async
}

@MainActor
@Observable
final class MediaListDefaultPresenter: MediaListPresenter {

    private(set) var isLoading = false
    private(set) var hasMore = true
    var fetchError: Error?

    private(set) var interactor: MediaInteractor
    private(set) var section: MediaSection
    var mediaList: [Watchable]

    init(_ interactor: MediaInteractor, section: MediaSection) {
        self.interactor = interactor
        self.section = section
        self.mediaList = [Watchable]()
    }

    func fetchMedia() async {
        guard hasMore, !isLoading, !Task.isCancelled else { return }
        isLoading = true
        fetchError = nil
        defer { isLoading = false }
        do {
            let media = try await interactor.fetchMedia(in: section)
            try Task.checkCancellation()
            hasMore = media.count > mediaList.count
            mediaList = media
        } catch {
            guard !Task.isCancelled, !(error is CancellationError) else { return }
            fetchError = error
        }
    }
}
