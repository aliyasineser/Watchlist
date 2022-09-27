//
//  WathableEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

protocol Watchable: Codable {
    var id: Int { get }
    func getTitle() -> String
    func getImagePath() -> String
    func getReleaseDate() -> String?
    func getOverview() -> String
    func getVoteAverage() -> Double?
    func getID() -> Int
    func getPosterUrl() -> String
}

extension Watchable {
    func getPosterUrl() -> String {
        APIConstants.defaultScheme +
        APIConstants.baseImgUrl + APIConstants.baseImgUrlPath +
        getImagePath()
    }
}
