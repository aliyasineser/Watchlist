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

    var getSimilarMediaCallStub: [Watchlist.Watchable] = []
    var getSimilarMediaCallCalledOnce: Bool = false

    func getSimilarMedia(_ id: Int, page: Int) async -> [Watchlist.Watchable] {
        return try! await withCheckedThrowingContinuation { continuation in
            getSimilarMediaCallCalledOnce = true
            continuation.resume(returning: getSimilarMediaCallStub)
        }
    }

    var mediaServiceStub: Watchlist.MediaService = MediaServiceMock()
    var mediaService: Watchlist.MediaService { mediaServiceStub }
}
