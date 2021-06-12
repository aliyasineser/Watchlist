//
//  GenresPresenter.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 6.06.2021.
//

import Foundation
import TMDBSwift

class GenresPresenter: ObservableObject {
    
    var interactor: GenresInteractor
    @Published var genres: [GenreEntity]
    
    init(_ interactor: GenresInteractor) {
        self.interactor = interactor
        self.genres = []
    }
    
    func fetchGenres() -> Void {
        interactor.fetchGenres { (genres) in
            genres.forEach { (genre) in
                if let id = genre.id, let name = genre.name {
                    self.genres.append(GenreEntity(id: id, name: name))
                }
            }
        }
    }
    
}
