//
//  MovieDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation
import Combine
import SwiftUI
import TMDBSwift

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
    
    func getMediaDetail() -> Void {
        switch self.mediaType {
        case .movie:
            getMovieDetail(self.mediaId)
        case .tv:
            getTvDetail(self.mediaId)
        }
    }
    
    func getMovieDetail(_ id: Int) {
        interactor.getMovieDetail(id) { movieDetail in
            if let detail = movieDetail, let title = detail.title, let time = detail.runtime,
               let point = detail.vote_average, let summary = detail.overview, let lang = detail.original_language, let date = detail.release_date {
                self.media = MediaDetailEntity(id: detail.id, title: title, genres: "",
                                               point: point, language: OriginalLanguage(language: lang)?.language ?? lang,
                                               date: date, time: String(format: "%dh %dm", time/60, time%60),
                                               summary: summary, image_path: detail.getPosterUrl(), mediaType: .movie)
                self.media.genres = movieDetail?.genresAsString() ?? ""
            }
        }
    }
    
    func getTvDetail(_ id: Int) {
        interactor.getTvDetail(id) { tvDetail in
            if let detail = tvDetail, let title = detail.original_name, let time = detail.episode_run_time,
               let point = detail.vote_average, let summary = detail.overview, let lang = detail.original_language, let date = detail.first_air_date {
                self.media = MediaDetailEntity(id: detail.id, title: title, genres: "",
                                               point: point, language: OriginalLanguage(language: lang)?.language ?? lang,
                                               date: date, time: String(format: "%dh %dm", (time.first ?? 0)/60, (time.first ?? 0)%60),
                                               summary: summary, image_path: detail.getPosterUrl(), mediaType: .tv)

                self.media.genres = tvDetail?.genresAsString() ?? ""
            }
        }
    }
    
}
