//
//  MovieMock.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 10.01.2022.
//

import Foundation

class MovieMocks {
    
    static let mediaStub: Media = Media(adult: true,
                                        backdropPath: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg",
                                        genreIDS: [1], id: 1, mediaType: .movie, originalLanguage: OriginalLanguage.en, originalTitle: "No way home",
                                        posterPath: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", overview: "Nice movie ", releaseDate: "2021 - 06 - 26", title: "No way home", video: true, voteAverage: 5, voteCount: 5000000, firstAirDate: "2021 - 05 - 21", name: "No way home", originCountry: [], originalName: "No way home", popularity: 1000)
    
    
    static let discoverSectionItemListItemStub: DiscoverSectionItemEntity = DiscoverSectionItemEntity(id: 1, title: "Very Very  Movie Title ", year: "31 - 07 - 2021", imgUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", genre: "Comedy", mediaType: .movie)
    
}
