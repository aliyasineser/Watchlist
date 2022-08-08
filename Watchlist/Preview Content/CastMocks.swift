//
//  ArtistMocks.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 11.01.2022.
//

import Foundation

class CastMocks {

    static let artistEntity: ArtistEntity = ArtistEntity(artistId: 1, imageUrl: "", name: "Artist_Name Artist_Surname")

    static let castEntity: CastEntity = CastEntity(imageUrl: "", name: "Artist_Name Artist_Surname",
                                                   character: "Character")

    static let artistDetailEntity: ArtistDetailEntity = ArtistDetailEntity(id: 1, name: "Artist Name",
                                                                       biography: "Artist Lived a long happy life. ",
                                                                       birthday: "21 - 05 - 1921",
                                                                       deathday: "02 - 02 - 2022",
                                                                       asKnownAs: ["Yoyo person", "Nonnoooo Person"],
                                                                       placeOfBirth: "Old Yorkshire",
                                                                       imgUrl: "www.image.com")

}
