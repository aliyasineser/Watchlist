//
//  CommonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

struct Credits: Codable, Equatable {
    let cast, crew: [Cast]
    let id: Int?
}

extension Credits {
    static let mock = Credits(cast: [], crew: [], id: 1)
}

struct SpokenLanguage: Codable, Equatable {
    let englishName, iso639_1, name: String // swiftlint:disable:this identifier_name

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1" // swiftlint:disable:this identifier_name
        case name
    }
}

struct ProductionCountry: Codable, Equatable {
    let iso3166_1, name: String // swiftlint:disable:this identifier_name

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1" // swiftlint:disable:this identifier_name
        case name
    }
}

struct Genre: Codable, Equatable {
    var id: Int
    var name: String
}

struct Company: Codable, Equatable {
    var id: Int
    var name: String
    var logoPath: String
    var originCountry: String
}

struct Production: Codable, Equatable {
    var iso3166_1: String // swiftlint:disable:this identifier_name
    var name: String
}

enum Department: String, Codable, Equatable {
    case acting = "Acting"
    case art = "Art"
    case camera = "Camera"
    case costumeMakeUp = "Costume & Make-Up"
    case crew = "Crew"
    case directing = "Directing"
    case editing = "Editing"
    case production = "Production"
    case sound = "Sound"
    case visualEffects = "Visual Effects"
    case writing = "Writing"
    case lighting = "Lighting"
    case creator = "Creator"
    case actor = "Actors"
}

struct ProductionCompany: Codable, Equatable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}
