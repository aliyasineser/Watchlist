//
//  PersonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation


protocol Creditable : Codable {
    func getTitle() -> String
    func getImagePath() -> String
}


struct PopularArtists: Codable {
    let page: Int
    let results: [Artist]?
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Artist: Codable, Creditable {
    let adult: Bool
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday, deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbID, knownForDepartment: String?
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, homepage, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    func getTitle() -> String {
        return name
    }
    
    func getImagePath() -> String {
        return profilePath ?? ""
    }
}


struct Cast: Codable, Creditable {
    let adult: Bool
    let gender, id: Int
    let knownForDepartment: Department?
    let name, originalName: String
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: Department?
    let job: String?
    
    enum CodingKeys: String, CodingKey {
        case adult, gender, id
        case knownForDepartment = "known_for_department"
        case name
        case originalName = "original_name"
        case popularity
        case profilePath = "profile_path"
        case castID = "cast_id"
        case character
        case creditID = "credit_id"
        case order, department, job
    }
    
    func getTitle() -> String {
        return name
    }
    
    func getImagePath() -> String {
        return profilePath ?? ""
    }
    
    func getRole() -> String {
        return character ?? job ?? department?.rawValue ?? ""
    }
}
