//
//  ArtistImageEntity.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 30.10.2021.
//

import Foundation

struct ArtistImageEntity: Identifiable {
    var id = UUID()
    var aspectRatio: Double
    var filePath: String
    var height: Int
    var iso_639_1: String // swiftlint:disable:this identifier_name
    var voteAverage: Double
    var voteCount: Int
    var width: Int

    func getPosterUrl() -> String {
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + filePath
    }
}
