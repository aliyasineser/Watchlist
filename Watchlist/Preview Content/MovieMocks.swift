//
//  MovieMock.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 10.01.2022.
//

import Foundation

class MovieMocks {
    
    static let movieListItem: MovieListItemEntity = MovieListItemEntity(id: 1, title: "Long Long Movie Title",
                                                         year: "2021",
                                                         imgUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg",
                                                         rating: 3.3, genres: "Genre | Genre | Genre ", mediaType: .movie )
    
    
    static let discoverSectionItemListItem: DiscoverSectionItemEntity = DiscoverSectionItemEntity(id: 1, title: "Very Very  Movie Title ", year: "31 - 07 - 2021", imgUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", genre: "Comedy", mediaType: .movie)
    
}
