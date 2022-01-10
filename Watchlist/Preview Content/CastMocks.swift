//
//  ArtistMocks.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 11.01.2022.
//

import Foundation


class CastMocks {
    
    static let artistEntity: ArtistEntity = ArtistEntity(artistId: 1, imageUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", name: "Artist_Name Artist_Surname")

    static let castEntity: CastEntity = CastEntity(imageUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", name: "Artist_Name Artist_Surname", character: "Character")
    
    static let artistDetailEntity: ArtistDetailEntity = ArtistDetailEntity(id: 1, name: "Artist Name", biography: "Artist Lived a long happy life. ", birthday: "21 - 05 - 1921", deathday: "02 - 02 - 2022", as_known_as: ["Yoyo person", "Nonnoooo Person"], place_of_birth: "Old Yorkshire", imgUrl: "www.image.com")
    
}
