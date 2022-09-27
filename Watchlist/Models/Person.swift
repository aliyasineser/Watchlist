//
//  PersonEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.08.2022.
//

import Foundation

// MARK: Creditable
protocol Creditable: Codable {
    var id: Int { get }
    func getTitle() -> String
    func getImagePath() -> String
    func getKnownForDepartment() -> String?
    func getPosterUrl() -> String
}

// MARK: PopularArtists
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

// MARK: Artist
struct Artist: Codable, Creditable {

    let adult: Bool
    let alsoKnownAs: [String]?
    let biography: String?
    let birthday, deathday: String?
    let gender: Int?
    let homepage: String?
    let id: Int
    let imdbID: String?
    let knownForDepartment: Department?
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

    func getKnownForDepartment() -> String? {
        knownForDepartment?.rawValue
    }

    func getTitle() -> String { return name }

    func getImagePath() -> String { return profilePath ?? "" }

    func getPosterUrl() -> String {
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + getImagePath()
    }
}

extension Artist {
    static let mock = Artist(adult: true,
                             alsoKnownAs: ["KnownAs"],
                             biography: "Lived a great life",
                             birthday: "01-01-1991",
                             deathday: "01-01-2021",
                             gender: 1,
                             homepage: "www.homepage.com",
                             id: 1,
                             imdbID: "IMDB-ID",
                             knownForDepartment: .acting,
                             name: "Actress Name",
                             placeOfBirth: "London",
                             popularity: 10,
                             profilePath: "Profile Path"
    )
}

// MARK: ArtistDetail
struct ArtistDetail: Codable, Identifiable {
    let birthday, knownForDepartment: String?
    let deathday: String?
    let id: Int
    let name: String
    let alsoKnownAs: [String]?
    let gender: Int?
    let biography: String?
    let popularity: Double?
    let placeOfBirth, profilePath: String?
    let adult: Bool
    let imdbID: String?
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case birthday
        case knownForDepartment = "known_for_department"
        case deathday, id, name
        case alsoKnownAs = "also_known_as"
        case gender, biography, popularity
        case placeOfBirth = "place_of_birth"
        case profilePath = "profile_path"
        case adult
        case imdbID = "imdb_id"
        case homepage
    }

    func getPosterUrl() -> String {
        APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + (profilePath ?? "")
    }
}

extension ArtistDetail {
    static let mock = ArtistDetail(
        birthday: "01-01-1994",
        knownForDepartment: "Department",
        deathday: "01-01-2009",
        id: 1,
        name: "Name",
        alsoKnownAs: [],
        gender: 1,
        biography: "Biography",
        popularity: 10,
        placeOfBirth: "Place",
        profilePath: "ProfilePath",
        adult: false,
        imdbID: "IMDB ID",
        homepage: "www.homepage.com"
    )
}

// MARK: Crew & Cast
typealias Crew = Cast
struct Cast: Codable, Creditable, Identifiable {
    let adult: Bool
    let gender: Int?
    let id: Int
    let knownForDepartment: Department?
    let name: String?
    let originalName: String?
    let popularity: Double
    let profilePath: String?
    let castID: Int?
    let character: String?
    let creditID: String
    let order: Int?
    let department: Department?
    let job: String?
    let backdropPath: String?
    let genreIDS: [Int]?
    let originalLanguage: OriginalLanguage?
    let originalTitle, overview: String?
    let posterPath: String?
    let releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

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
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    func getKnownForDepartment() -> String? {
        knownForDepartment?.rawValue
    }

    func getTitle() -> String { return title ?? originalTitle ?? originalName ?? "" }

    func getImagePath() -> String { return posterPath ?? profilePath ?? "" }

    func getRole() -> String { return character ?? job ?? department?.rawValue ?? "" }

    func getPosterUrl() -> String {
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + getImagePath()
    }
}

extension Cast {
    static let mock = Cast(
        adult: true,
        gender: 1,
        id: 1,
        knownForDepartment: .acting,
        name: "Name",
        originalName: "Original Name",
        popularity: 10,
        profilePath: "ProfilePath",
        castID: 12,
        character: "Character",
        creditID: "CreditID",
        order: 1,
        department: .acting,
        job: "Job",
        backdropPath: "BackdropPath",
        genreIDS: [],
        originalLanguage: .en,
        originalTitle: "Original Title",
        overview: "Overview",
        posterPath: "PostPath",
        releaseDate: "01-01-1994",
        title: "Title",
        video: false,
        voteAverage: 7.2,
        voteCount: 1000
    )
}
