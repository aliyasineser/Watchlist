//
//  DiscoverPresenter.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import Foundation
import TMDBSwift

class DiscoverPresenter: ObservableObject {
    
    private let interactor: DiscoverInteractor
    @Published var popularMovies: [MovieMDB]
    
    init(_ interactor: DiscoverInteractor) {
        self.interactor = interactor
        self.popularMovies = [MovieMDB]()
    }
    
    func loadPopularMovies() -> Void {
        interactor.fetchNextPopularPageAsFullList(updater: { (movies) in
            self.popularMovies = movies
            debugPrint("Coming")
            debugPrint(self.popularMovies)
        })
    }
    
    
}
