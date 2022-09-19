//
//  UpcomingMoviesFetchStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

final class UpcomingMoviesFetchStrategy: MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest {
        MovieRequest.getUpcomingMovies(page: page)
    }
}
