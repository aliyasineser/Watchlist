//
//  MediaDetailPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.08.2021.
//

import Foundation
import Combine

@MainActor
protocol MovieDetailPresenter: ObservableObject {
    var id: Int { get }
    var interactor: MovieDetailInteractor { get }
    var media: MovieDetail { get }

    func getMediaDetail()
    func getMovieDetail(_ id: Int) async
}

final class MovieDetailDefaultPresenter: MovieDetailPresenter {
    private(set) var interactor: MovieDetailInteractor
    @Published var media: MovieDetail = MovieDetail.mock
    let id: Int

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
        guard let movieDetail = await interactor.getMovieDetail(id) else { return }
        guard let detail = movieDetail as? MovieDetail else { return }
        self.media = detail
    }
}
