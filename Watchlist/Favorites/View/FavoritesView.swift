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
            .frame(height: 200)
            .aspectRatio(0.66, contentMode: .fit)
            .clipped()
            .border(width: 1, edges: Edge.allCases, color: .primary)
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Section {
                    ForEach(presenter.artists) { artist in
                        HStack(spacing: 30) {
                            imageView(url: artist.getPosterUrl())
                            Text(artist.name)
                        }
                        .padding(.horizontal, 20)
                    }
                } header: {
                    Text(ConstantTexts.FavoritesSections.artists)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    ForEach(presenter.movies, id: \.id) { movie in
                        HStack(spacing: 30) {
                            imageView(url: movie.posterUrl())
                            Text(movie.title)
                        }
                        .padding(.horizontal, 20)
                    }
                } header: {
                    Text(ConstantTexts.FavoritesSections.movies)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    ForEach(presenter.tvSeries, id: \.id) { tvSerie in
                        HStack(spacing: 30) {
                            imageView(url: tvSerie.posterUrl())
                            Text(tvSerie.title)
                        }
                        .padding(.horizontal, 20)
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
