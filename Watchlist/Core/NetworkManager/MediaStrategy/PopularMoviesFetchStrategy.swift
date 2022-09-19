//
//  PopularMoviesFetchStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

final class PopularMoviesFetchStrategy: MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest {
        MovieRequest.getPopularMovies(page: page)
    }
}
