//
//  ArtistInteractor.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import Foundation

protocol ArtistInteractor {
    func fetchArtists() async -> [Artist]
}

final class DefaultArtistInteractor: ArtistInteractor {

    let artistFetcher: ArtistFetcher = ArtistFetcher()

    func fetchArtists() async -> [Artist] {
        return await artistFetcher.fetchSinglePage()
    }

}

final class ArtistInteractorStub: ArtistInteractor {
    func fetchArtists() async -> [Artist] {
        var artists: [Artist] = []
        for _ in 0..<9 {
            artists.append(Artist.mock)
        }
        return artists
    }
}
