//
//  FavoritesInteractor.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import Foundation

protocol FavoritesInteractor {
    func getFavoriteArtists() async -> [ArtistDetail]
    func getFavoriteMovies() async -> [WatchableDetail]
    func getFavoriteSeries() async -> [WatchableDetail]
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

    func getFavoriteMovies() async -> [WatchableDetail] {
        let infoList = movieStorage.fetchMovies()
        var favorites: [WatchableDetail] = []
        for info in infoList {
            if let details = await movieService.fetchMediaDetails(id: Int(info.id)) {
                favorites.append(details)
            }
        }
        return favorites
    }

    func getFavoriteSeries() async -> [WatchableDetail] {
        let infoList = tvSerieStorage.fetchSeries()
        var favorites: [WatchableDetail] = []
        for info in infoList {
            if let details = await tvSerieService.fetchMediaDetails(id: Int(info.id)) {
                favorites.append(details)
            }
        }
        return favorites
    }

}
