//
//  MovieListView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

@MainActor
struct MovieListView: View {
    
    init(section: MediaSection) {
        self.section = section
        self.interactor = MovieListInteractor()
        self.presenter = MovieListPresenter(interactor, section: section)
        self.presenter.fetchMedia()
    }
    
    var section: MediaSection
    var interactor: MovieListInteractor
    var presenter: MovieListPresenter
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                ForEach(self.presenter.mediaList) { (media: MovieListItemEntity) -> MovieListItemView in
                    MovieListItemView(movieListItem: media)
                }
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(section: MediaSection.popularMovies)
    }
}
