//
//  WatchableToMediaMapper.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 4.08.2022.
//

import Foundation


enum WatchableToMediaMapper {

    static func convert(from: Watchable, type: MediaType) -> Media? {
        if let movie = from as? Movie {
            return Media(adult: movie.adult, backdropPath: movie.backdropPath, genreIDS: movie.genreIDS, id: movie.id, mediaType: .movie, originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle, posterPath: movie.posterPath, overview: movie.overview, releaseDate: movie.releaseDate, title: movie.title, video: movie.video, voteAverage: movie.voteAverage ?? 0, voteCount: movie.voteCount, firstAirDate: movie.releaseDate ?? "", name: movie.title, originCountry: [], originalName: movie.originalTitle, popularity: movie.popularity)
        } else if let serie = from as? TVSerie {
            return Media(adult: nil, backdropPath: serie.backdropPath, genreIDS: serie.genreIDS, id: serie.id, mediaType: .tv, originalLanguage: serie.originalLanguage, originalTitle: serie.originalName, posterPath: serie.posterPath, overview: serie.overview, releaseDate: serie.firstAirDate, title: serie.name, video: nil, voteAverage: serie.voteAverage ?? 0, voteCount: serie.voteCount, firstAirDate: serie.firstAirDate ?? "", name: serie.name, originCountry: [], originalName: serie.originalName, popularity: serie.popularity)
        }
        return nil
    }
    
}
