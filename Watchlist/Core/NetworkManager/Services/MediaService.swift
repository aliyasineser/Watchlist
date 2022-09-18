//
//  MediaService.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 18.09.2022.
//

import Foundation

protocol MediaService {
    func fetchMedia(request: NetworkRequest) async -> [Media]
    func fetchMediaDetails(id: Int) async -> MediaDetail?
    func fetchMediaCredits(id: Int) async -> Credits?
}
