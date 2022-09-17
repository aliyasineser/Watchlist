//
//  MovieListView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

@MainActor
struct MovieListView: View {

    init(movieListPresenter: MovieListPresenter) {
        self.presenter = movieListPresenter
        self.presenter.fetchMedia()
    }

    var presenter: MovieListPresenter

    var body: some View {

        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                ForEach(self.presenter.mediaList) { media in
                    MovieListItemView(movieListItem: media)
                }
            }
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView(movieListPresenter: MovieListPresenter(MovieListInteractorStub(), section: .comingSoonMovies)
        )
    }
}
