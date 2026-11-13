//
//  MediaSimilarInteractorMock.swift
//  WatchlistTests
//
//  Created by Ali Yasin Eser on 18.10.2022.
//

// swiftlint:disable:all force_try
import Foundation
@testable import Watchlist

final class MediaSimilarInteractorMock: MediaSimilarInteractor {
    var error: Error?
    var requestedPages: [Int] = []

    var getSimilarMediaCallStub: [Watchlist.Watchable] = []
    var getSimilarMediaCallCalledOnce: Bool = false

    func getSimilarMedia(_ id: Int, page: Int) async throws -> [Watchlist.Watchable] {
        requestedPages.append(page)
        if let error { throw error }
        getSimilarMediaCallCalledOnce = true
        return getSimilarMediaCallStub
    }

    var mediaServiceStub: Watchlist.MediaService = MediaServiceMock()
    var mediaService: Watchlist.MediaService { mediaServiceStub }
}
