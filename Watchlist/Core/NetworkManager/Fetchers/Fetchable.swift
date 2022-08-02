//
//  Fetchable.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

protocol Fetchable {
    func fetchSinglePage() async -> [Watchable]
    func fetchWithNextPage() async -> [Watchable]
    func getFetched() -> [Watchable]
}
