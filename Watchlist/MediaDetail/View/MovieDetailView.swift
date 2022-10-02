//
//  MediaDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 5.07.2021.
//

import SwiftUI
import CachedAsyncImage

struct MovieDetailView: View {

    @ObservedObject var presenter: MovieDetailDefaultPresenter
    @State var isFavorite = false

    init(presenter: MovieDetailDefaultPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
    }

    fileprivate func mediaView() -> some View {
        return HStack(alignment: .top) {
            MediaHeaderView(imageUrl: presenter.media.posterUrl())
            VStack(alignment: .leading) {
                MediaDetailsView(
                    title: presenter.media.title,
                    genres: presenter.media.genres.first?.name,
                    rating: presenter.media.voteAverage,
                    language: presenter.media.originalLanguage,
                    date: presenter.media.releaseDate,
                    time: nil
                )

            }
            .padding(.leading, 5)
            Spacer()
            FavoriteButton(favoriteStorage: presenter.favoriteStorage,
                           isFavorite: $isFavorite,
                           id: presenter.id,
                           title: presenter.media.title
            )
            .padding(.leading, 10)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        mediaView()
                            .padding(.horizontal, 10)
                            .frame(width: geometry.size.width, alignment: .top)
                        if let overview = presenter.media.overview {
                            ScrollView {
                                Text(overview)
                                    .font(.system(size: 16))
                            }
                            .padding(.horizontal, 10)
                            .padding(.top, 25)
                        }

                        MediaDetailTabView(
                            self.presenter.id,
                            mediaService: MovieService.shared
                        )
                        .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle(self.presenter.media.title)
        .onAppear {
            presenter.getMediaDetail()
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MovieDetailView(
                presenter: MovieDetailDefaultPresenter(
                    interactor: MovieDetailInteractorStub(),
                    id: 1285
                )
            )
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
