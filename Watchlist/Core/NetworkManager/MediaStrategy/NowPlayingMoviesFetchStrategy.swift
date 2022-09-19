//
//  NowPlayingMoviesFetchStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

final class NowPlayingMoviesFetchStrategy: MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest {
        MovieRequest.getNowPlayingMovies(page: page)
    }
}
