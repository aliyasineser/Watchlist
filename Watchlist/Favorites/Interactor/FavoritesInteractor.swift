//
//  FavoritesInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation

protocol FavoritesInteractor {
    func getFavoriteArtists() async -> [ArtistDetail]
    func getFavoriteMovies() async -> [Watchable]
    func getFavoriteSeries() async -> [Watchable]
}

final class DefaultFavoritesInteractor: FavoritesInteractor {

    let artistStorage = FavoriteArtistStorage.shared
    let movieStorage = FavoriteMovieStorage.shared
    let tvSerieStorage = FavoriteTVSerieStorage.shared

    let artistService = ArtistService.shared
    let movieService = MovieService.shared
    let tvSerieService = TVService.shared

    func getFavoriteArtists() async -> [ArtistDetail] {
        let artistsInfoList = artistStorage.fetchArtists()
        var favoriteArtists: [ArtistDetail] = []
        for artistInfo in artistsInfoList {
            if let artist = await artistService.fetchArtistDetail(id: Int(artistInfo.id)) {
                favoriteArtists.append(artist)
            }
        }
        return favoriteArtists
    }

    func getFavoriteMovies() async -> [Watchable] {
        let infoList = movieStorage.fetchMovies()
        var favorites: [Watchable] = []
        for info in infoList {
            if let details = await movieService.fetchMediaDetails(id: Int(info.id)) {
                favorites.append(details)
            }
        }
        return favorites
    }

    func getFavoriteSeries() async -> [Watchable] {
        let infoList = tvSerieStorage.fetchSeries()
        var favorites: [Watchable] = []
        for info in infoList {
            if let details = await tvSerieService.fetchMediaDetails(id: Int(info.id)) {
                favorites.append(details)
            }
        }
        return favorites
    }

}
