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
struct Artist: Codable, Creditable, Equatable {

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
struct Cast: Codable, Creditable, Identifiable, Equatable {
    internal init(
        adult: Bool,
        gender: Int? = nil,
        id: Int,
        knownForDepartment: Department? = nil,
        name: String? = nil,
        originalName: String? = nil,
        popularity: Double,
        profilePath: String? = nil,
        castID: Int? = nil,
        character: String? = nil,
        creditID: String,
        order: Int? = nil,
        department: Department? = nil,
        job: String? = nil,
        backdropPath: String? = nil,
        genreIDS: [Int]? = nil,
        originalLanguage: OriginalLanguage? = nil,
        originalTitle: String? = nil,
        overview: String? = nil,
        posterPath: String? = nil,
        releaseDate: Date? = nil,
        title: String? = nil,
        video: Bool? = nil,
        voteAverage: Double? = nil,
        voteCount: Int? = nil
    ) {
        self.adult = adult
        self.gender = gender
        self.id = id
        self.knownForDepartment = knownForDepartment
        self.name = name
        self.originalName = originalName
        self.popularity = popularity
        self.profilePath = profilePath
        self.castID = castID
        self.character = character
        self.creditID = creditID
        self.order = order
        self.department = department
        self.job = job
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.adult = try container.decode(Bool.self, forKey: .adult)
        self.gender = try container.decodeIfPresent(Int.self, forKey: .gender)
        self.id = try container.decode(Int.self, forKey: .id)
        self.knownForDepartment = try container.decodeIfPresent(Department.self, forKey: .knownForDepartment)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.originalName = try container.decodeIfPresent(String.self, forKey: .originalName)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath)
        self.castID = try container.decodeIfPresent(Int.self, forKey: .castID)
        self.character = try container.decodeIfPresent(String.self, forKey: .character)
        self.creditID = try container.decode(String.self, forKey: .creditID)
        self.order = try container.decodeIfPresent(Int.self, forKey: .order)
        self.department = try container.decodeIfPresent(Department.self, forKey: .department)
        self.job = try container.decodeIfPresent(String.self, forKey: .job)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
        self.genreIDS = try container.decodeIfPresent([Int].self, forKey: .genreIDS)
        self.originalLanguage = try container.decodeIfPresent(OriginalLanguage.self, forKey: .originalLanguage)
        self.originalTitle = try container.decodeIfPresent(String.self, forKey: .originalTitle)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.video = try container.decodeIfPresent(Bool.self, forKey: .video)
        self.voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage)
        self.voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount)

        let release = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        let formatter = DateFormatter.yyyyMMdd
        self.releaseDate = formatter.date(from: release ?? "")
    }

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
    let releaseDate: Date?
    let title: String?
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
        releaseDate: .distantPast,
        title: "Title",
        video: false,
        voteAverage: 7.2,
        voteCount: 1000
    )
}
