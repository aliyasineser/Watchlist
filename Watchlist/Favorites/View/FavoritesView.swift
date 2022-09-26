//
//  FavoritesView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import SwiftUI
import CachedAsyncImage
import Combine

struct FavoritesView: View {
    @ObservedObject private var presenter: FavoritesPresenter

    init(presenter: FavoritesPresenter) {
        self.presenter = presenter
    }

    fileprivate func artistImage(url: String) -> some View {
        return CachedAsyncImage(
            url: URL(string: url),
            content: { image in
                image.resizable()
                    .scaledToFill()
                    .aspectRatio(0.66, contentMode: .fit)
                    .frame(height: 300)
                    .clipped()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(0.66, contentMode: .fit)
                    .frame(height: 300)
                    .clipped()
            }
        )
        .border(width: 1, edges: Edge.allCases, color: .primary)
    }

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                Section {
                    ForEach(presenter.artists) { artist in
                        HStack {
                            artistImage(url: artist.getPosterUrl())
                            Spacer()
                            Text(artist.name)
                        }
                        .padding(.horizontal, 20)
                    }
                } header: {
                    Text("Artists")
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    ForEach(presenter.movies, id: \.id) { movie in
                        HStack {
                            artistImage(url: movie.getPosterUrl())
                            Spacer()
                            Text(movie.getTitle())
                        }
                        .padding(.horizontal, 20)
                    }
                } header: {
                    Text("Movies")
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                }

                Section {
                    ForEach(presenter.tvSeries, id: \.id) { tvSerie in
                        HStack {
                            artistImage(url: tvSerie.getPosterUrl())
                            Spacer()
                            Text(tvSerie.getTitle())
                        }
                        .padding(.horizontal, 20)
                    }
                } header: {
                    Text("TV Series")
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
            presenter: FavoritesPresenter(
                DefaultFavoritesInteractor()
            )
        )
    }
}
