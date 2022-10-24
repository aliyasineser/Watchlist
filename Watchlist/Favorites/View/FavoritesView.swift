//
//  FavoritesView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import SwiftUI
import Combine
import Kingfisher

struct FavoritesView: View {
    @ObservedObject private var presenter: FavoritesDefaultPresenter

    init(presenter: FavoritesDefaultPresenter) {
        self.presenter = presenter
    }

    fileprivate func imageView(url: String) -> some View {
        return KFImage(URL(string: url))
            .cacheOriginalImage()
            .resizable()
            .frame(height: 175)
            .aspectRatio(0.66, contentMode: .fit)
            .clipped()
            .border(width: 1, edges: Edge.allCases, color: .primary)
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Section {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100))],
                        alignment: .center
                    ) {
                        ForEach(presenter.artists) { artist in
                            imageView(url: artist.getPosterUrl())
                        }
                    }
                } header: {
                    Text(ConstantTexts.FavoritesSections.artists)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100))],
                        alignment: .center
                    ) {
                        ForEach(presenter.movies, id: \.id) { movie in
                            imageView(url: movie.posterUrl())
                        }
                    }
                } header: {
                    Text(ConstantTexts.FavoritesSections.movies)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    LazyVGrid(
                        columns: [GridItem(.adaptive(minimum: 100))],
                        alignment: .center
                    ) {
                        ForEach(presenter.tvSeries, id: \.id) { tvSerie in
                            imageView(url: tvSerie.posterUrl())
                        }
                    }
                } header: {
                    Text(ConstantTexts.FavoritesSections.tvSeries)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

            }
            .navigationTitle(ConstantTexts.NavigationBarTitle.favoritesScreen)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                presenter.fetchFavorites()
            }
        }

    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(
            presenter: FavoritesDefaultPresenter(
                DefaultFavoritesInteractor()
            )
        )
    }
}
