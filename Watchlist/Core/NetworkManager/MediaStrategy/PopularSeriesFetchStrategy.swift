//
//  PopularSeriesFetchStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

final class PopularSeriesFetchStrategy: MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest {
        TVRequest.getPopularSeries(page: page)
    }
}
