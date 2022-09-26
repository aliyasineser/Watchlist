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
class MovieDetailPresenter: ObservableObject {
    let interactor: MovieDetailInteractor
    @Published var media: MediaDetailEntity = MediaDetailEntity()
    public let id: Int

    init(interactor: MovieDetailInteractor, id: Int) {
        self.interactor = interactor
        self.id = id
    }

    func getMediaDetail() {
        Task {
            await getMovieDetail(self.id)
        }
    }

    func getMovieDetail(_ id: Int) async {
        let movieDetail = await interactor.getMovieDetail(id)
        guard let detail = movieDetail as? MovieDetail,
                let time = detail.runtime,
                let summary = detail.overview
        else { return }
        
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
