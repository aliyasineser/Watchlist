//
//  CommonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

struct Credits: Codable {
    let cast, crew: [Cast]
    let id: Int?
}

extension Credits {
    static let mock = Credits(cast: [], crew: [], id: 1)
}

struct SpokenLanguage: Codable {
    let englishName, iso639_1, name: String // swiftlint:disable:this identifier_name

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639_1 = "iso_639_1" // swiftlint:disable:this identifier_name
        case name
    }
}

struct ProductionCountry: Codable {
    let iso3166_1, name: String // swiftlint:disable:this identifier_name

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1" // swiftlint:disable:this identifier_name
        case name
    }
}

struct Genre: Codable {
    var id: Int
    var name: String
}

struct Company: Codable {
    var id: Int
    var name: String
    var logoPath: String
    var originCountry: String
}

struct Production: Codable {
    var iso3166_1: String // swiftlint:disable:this identifier_name
    var name: String
}

enum Department: String, Codable {
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
}

struct ProductionCompany: Codable {
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
