//
//  OnTheAirSeriesFetchStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

final class OnTheAirSeriesFetchStrategy: MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest {
        TVRequest.getOnTheAirSeries(page: page)
    }
}
