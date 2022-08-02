//
//  TMDBExtentions.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 4.06.2021.
//

import Foundation

extension Media {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (posterPath ?? "")
    }
}

extension MovieDetail {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (posterPath ?? backdropPath ?? "")
    }
}

extension TvDetail {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (posterPath ?? backdropPath ?? "")
    }
}

extension Movie {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (posterPath ?? backdropPath ?? "")
    }
}

extension TVSerie {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (posterPath ?? backdropPath ?? "")
    }
}

extension ArtistDetail {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (profilePath ?? "")
    }
}

extension Cast {
    
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (profilePath ?? "")
    }
}

extension Crew {
    
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + profile_path
    }
}


extension Artist {
    func getPosterUrl() -> String {
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (profilePath ?? "")
    }
}
