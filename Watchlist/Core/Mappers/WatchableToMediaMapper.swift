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
            return Media(adult: movie.adult, backdropPath: movie.backdropPath, genreIDS: movie.genreIDS,
                         id: movie.id, mediaType: .movie,
                         originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle,
                         posterPath: movie.posterPath, overview: movie.overview,
                         releaseDate: movie.releaseDate, title: movie.title, video: movie.video,
                         voteAverage: movie.voteAverage ?? 0, voteCount: movie.voteCount,
                         firstAirDate: movie.releaseDate ?? "", name: movie.title,
                         originCountry: [], originalName: movie.originalTitle, popularity: movie.popularity)
        } else if let serie = from as? TVSerie {
            return Media(adult: nil, backdropPath: serie.backdropPath, genreIDS: serie.genreIDS,
                         id: serie.id, mediaType: .tv,
                         originalLanguage: serie.originalLanguage, originalTitle: serie.originalName,
                         posterPath: serie.posterPath, overview: serie.overview,
                         releaseDate: serie.firstAirDate, title: serie.name, video: nil,
                         voteAverage: serie.voteAverage ?? 0, voteCount: serie.voteCount,
                         firstAirDate: serie.firstAirDate ?? "", name: serie.name,
                         originCountry: [], originalName: serie.originalName, popularity: serie.popularity)
        }
        return nil
    }

    static func convertDetail(from: WatchableDetail, type: MediaType) -> MediaDetail? {
        if let movie = from as? MovieDetail {
            return MediaDetail(id: movie.id, adult: movie.adult,
                               posterPath: movie.posterPath, backdropPath: movie.backdropPath,
                               overview: movie.overview, releaseDate: movie.releaseDate,
                               genres: movie.genres, belongsToCollection: movie.belongsToCollection,
                               budget: movie.budget, homepage: movie.homepage, imdbID: movie.imdbID,
                               originalLanguage: movie.originalLanguage, originalTitle: movie.originalTitle,
                               popularity: movie.popularity, productionCompanies: movie.productionCompanies,
                               productionCountries: movie.productionCountries, revenue: movie.revenue,
                               runtime: movie.runtime, spokenLanguages: movie.spokenLanguages,
                               status: movie.status, title: movie.title, tagline: movie.tagline, video: movie.video,
                               voteAverage: movie.voteAverage, voteCount: movie.voteCount, credits: movie.credits,
                               createdBy: nil, episodeRunTime: nil, firstAirDate: nil, inProduction: false,
                               languages: nil, lastAirDate: nil, lastEpisodeToAir: nil, name: movie.title,
                               nextEpisodeToAir: nil, networks: movie.productionCompanies,
                               numberOfEpisodes: 1, numberOfSeasons: 1, originCountry: nil,
                               originalName: movie.originalTitle, seasons: nil, type: nil, mediaType: .movie)
        } else if let serie = from as? TvDetail {
            return MediaDetail(id: serie.id, adult: false,
                               posterPath: serie.posterPath, backdropPath: serie.backdropPath,
                               overview: serie.overview, releaseDate: serie.firstAirDate,
                               genres: serie.genres, belongsToCollection: nil, budget: 0,
                               homepage: serie.homepage, imdbID: nil,
                               originalLanguage: serie.originalLanguage, originalTitle: serie.originalName,
                               popularity: serie.popularity, productionCompanies: serie.productionCompanies,
                               productionCountries: serie.productionCountries, revenue: 0,
                               runtime: serie.episodeRunTime?.first, spokenLanguages: serie.spokenLanguages,
                               status: serie.status, title: serie.name, tagline: serie.tagline, video: false,
                               voteAverage: serie.voteAverage, voteCount: serie.voteCount, credits: serie.credits,
                               createdBy: serie.createdBy, episodeRunTime: serie.episodeRunTime,
                               firstAirDate: serie.firstAirDate, inProduction: serie.inProduction,
                               languages: serie.languages, lastAirDate: serie.lastAirDate,
                               lastEpisodeToAir: serie.lastEpisodeToAir, name: serie.name,
                               nextEpisodeToAir: serie.nextEpisodeToAir, networks: serie.networks,
                               numberOfEpisodes: serie.numberOfEpisodes, numberOfSeasons: serie.numberOfSeasons,
                               originCountry: serie.originCountry, originalName: serie.originalName,
                               seasons: serie.seasons, type: serie.type, mediaType: .tv)
        }
        return nil
    }
}
