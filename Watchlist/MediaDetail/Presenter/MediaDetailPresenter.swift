//
//  MediaDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation
import Combine
import SwiftUI

@MainActor
class MediaDetailPresenter: ObservableObject {
    let interactor: MediaDetailInteractor
    @Published var media: MediaDetailEntity = MediaDetailEntity()
    public let mediaId: Int
    public let mediaType: MediaType

    init(interactor: MediaDetailInteractor, movieId: Int, mediaType: MediaType) {
        self.interactor = interactor
        self.mediaId = movieId
        self.mediaType = mediaType
    }

    func getMediaDetail() {
        Task {
            switch self.mediaType {
            case .movie:
                await getMovieDetail(self.mediaId)
            case .tv:
                await getTvDetail(self.mediaId)
            }
        }
    }

    func getMovieDetail(_ id: Int) async {
        let movieDetail = await interactor.getMovieDetail(id)
        if let detail = movieDetail, let time = detail.runtime, let summary = detail.overview {
            self.media = MediaDetailEntity(
                id: detail.id,
                title: detail.title,
                genres: nil,
                point: detail.voteAverage,
                language: detail.originalLanguage,
                date: detail.getReleaseDate() ?? "",
                time: String(format: "%dh %dm", time/60, time%60),
                summary: summary,
                imageUrl: detail.getPosterUrl(),
                mediaType: .movie
            )
        }
    }

    func getTvDetail(_ id: Int) async {
        let tvDetail = await interactor.getTvDetail(id)
        if let detail = tvDetail,
           let firstAirDate = detail.getReleaseDate() {
            self.media = MediaDetailEntity(
                id: detail.id,
                title: detail.getTitle(),
                genres: nil,
                point: detail.voteAverage,
                language: detail.originalLanguage,
                date: firstAirDate,
                time: nil,
                summary: detail.getOverview(),
                imageUrl: detail.getPosterUrl(),
                mediaType: .tv
            )
        }
    }
}
