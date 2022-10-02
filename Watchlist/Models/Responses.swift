//
//  ResponseEntity.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 31.07.2022.
//

import Foundation

// MARK: - GenreResponse
struct GenreResponse: Codable {
    var genres: [Genre]?
}

// MARK: - ArtistImageResponse
struct ArtistImageResponse: Codable {
    let id: Int
    let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Codable {
    let aspectRatio: Double
    let filePath: String
    let height: Int
    let iso639_1: String? // swiftlint:disable:this identifier_name
    let voteAverage: Double
    let voteCount, width: Int

    enum CodingKeys: String, CodingKey {
        case aspectRatio = "aspect_ratio"
        case filePath = "file_path"
        case height
        case iso639_1 = "iso_639_1" // swiftlint:disable:this identifier_name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case width
    }

    func getPosterUrl() -> String {
        APIConstants.defaultScheme + APIConstants.baseImgUrl +
        APIConstants.baseImgUrlPath + filePath
    }
}

extension Profile {
    static let mock = Profile(
        aspectRatio: 1,
        filePath: "File Path",
        height: 200,
        iso639_1: "en-US",
        voteAverage: 5,
        voteCount: 10,
        width: 200
    )
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String
}

// MARK: - MovieResponse
struct MovieResponse: Codable {
    let dates: Dates?
    let page: Int
    var results: [Movie]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - TVSerieResponse
struct TVSerieResponse: Codable {
    let page: Int
    var results: [TVSerie]
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - MediaReviewResponse
struct MediaReviewResponse: Codable {
    let id, page: Int
    let results: [Review]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Review
struct Review: Codable, Identifiable {
    internal init(
        author: String,
        authorDetails: AuthorDetails,
        content: String,
        id: String,
        createdAt: Date? = nil,
        updatedAt: Date? = nil,
        url: String
    ) {
        self.author = author
        self.authorDetails = authorDetails
        self.content = content
        self.id = id
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.url = url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decode(String.self, forKey: .author)
        self.authorDetails = try container.decode(AuthorDetails.self, forKey: .authorDetails)
        self.content = try container.decode(String.self, forKey: .content)
        self.id = try container.decode(String.self, forKey: .id)
        self.url = try container.decode(String.self, forKey: .url)

        let formatter = DateFormatter.iso8601Full
        let creted = try container.decodeIfPresent(String.self, forKey: .createdAt)
        self.createdAt = formatter.date(from: creted ?? "")

        let updated = try container.decodeIfPresent(String.self, forKey: .updatedAt)
        self.updatedAt = formatter.date(from: updated ?? "")
    }

    let author: String
    let authorDetails: AuthorDetails
    let content, id: String
    let createdAt, updatedAt: Date?
    let url: String

    enum CodingKeys: String, CodingKey {
        case author
        case authorDetails = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

// swiftlint:disable:all line_length
extension Review {
    static let mock = Review(
        author: "Author",
        authorDetails: .mock,
        content:
"""
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam orci neque, convallis id bibendum et, dignissim ut diam. In at eros imperdiet, pharetra dui sed, scelerisque est. In fringilla purus eget odio iaculis, nec semper dolor euismod. Curabitur aliquet elementum ligula ut consectetur. Maecenas interdum interdum orci at congue. Vestibulum molestie auctor fringilla. Pellentesque eros mauris, sodales quis sapien blandit, finibus vestibulum quam. Sed iaculis sit amet lorem vulputate aliquet. Aliquam maximus, tellus at laoreet consequat, lacus turpis ultricies orci, sit amet vulputate arcu dolor a magna. Ut sit amet ante turpis. In sit amet dolor porttitor, hendrerit urna non, fringilla nisl. Quisque elementum ac magna eu sodales. Aliquam at malesuada velit. Vestibulum eu purus at massa tempus gravida. Quisque vel leo scelerisque nisl vehicula posuere a at metus.

Nullam elit mauris, hendrerit et nunc at, interdum auctor nibh. Integer nec odio viverra magna sagittis pellentesque. Praesent hendrerit leo eget facilisis condimentum. In nec nisi sit amet felis luctus rutrum nec eget elit. Proin vel libero dui. Donec eu magna bibendum, ultricies felis vitae, vehicula purus. Nulla venenatis euismod enim id fringilla. Sed ipsum urna, tincidunt mollis libero nec, finibus lobortis libero. Donec quis posuere mauris, sed vestibulum ipsum. Pellentesque ultrices hendrerit ipsum, nec vulputate est ornare vitae. Mauris porttitor dolor sed turpis scelerisque, ut aliquet nisi ornare. Donec rhoncus, mauris in interdum aliquam, lorem ligula auctor odio, non rhoncus purus est sit amet felis. Curabitur pulvinar justo molestie, vulputate urna id, mollis justo. Nam blandit pulvinar mi, imperdiet lacinia lacus hendrerit non. Proin scelerisque lacus eu risus egestas, vel finibus erat ultricies.
""",
        id: "1315",
        createdAt: .distantPast,
        updatedAt: .distantFuture,
        url: "URL"
    )
}

// MARK: - AuthorDetails
struct AuthorDetails: Codable {
    let name, username: String
    let avatarPath: String?
    let rating: Int?

    enum CodingKeys: String, CodingKey {
        case name, username
        case avatarPath = "avatar_path"
        case rating
    }

    func getAvatarUrl() -> URL? {
        let baseImagePath = APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath
        guard let avatarPath else { return nil }
        if avatarPath.contains("gravatar") {
            let substring = avatarPath.dropFirst()
            return URL(string: String(substring))
        }
        return URL(string: baseImagePath + avatarPath)
    }
}

extension AuthorDetails {
    static let mock = AuthorDetails(
        name: "Name",
        username: "Username",
        avatarPath: "Avatar Path",
        rating: 5
    )
}
