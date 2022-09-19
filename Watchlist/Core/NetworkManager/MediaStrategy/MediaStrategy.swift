//
//  MediaStrategy.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 19.09.2022.
//

import Foundation

protocol MediaListFetchStrategy {
    func fetch(page: Int) -> NetworkRequest
}
