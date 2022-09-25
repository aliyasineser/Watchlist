//
//  MediaDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 5.07.2021.
//

import SwiftUI
import CachedAsyncImage

struct MovieDetailView: View {

    @ObservedObject var presenter: MovieDetailPresenter
    let favoriteStorage: FavoriteStorage
    @State var isFavorite = false

    init(presenter: MovieDetailPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
        favoriteStorage = FavoriteMovieStorage.shared
    }

    fileprivate func mediaView() -> some View {
        return HStack(alignment: .top) {
            MediaHeaderView(imageUrl: presenter.media.imagePath)
            VStack(alignment: .leading) {
                MediaDetailsView(
                    title: presenter.media.title,
                    genres: presenter.media.genres,
                    rating: presenter.media.point,
                    language: presenter.media.language,
                    date: presenter.media.date,
                    time: presenter.media.time
                )

            }
            .padding(.leading, 5)
            Spacer()
            FavoriteButton(favoriteStorage: favoriteStorage,
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
                        PosterView(
                            imageUrl: presenter.media.imagePath,
                            height: 300,
                            width: geometry.size.width
                        )
                        .frame(alignment: .center)

                        mediaView()
                            .padding(.horizontal, 10)
                            .frame(width: geometry.size.width, alignment: .top)

                        ScrollView {
                            Text(presenter.media.summary)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 25)

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
                presenter: MovieDetailPresenter(
                    interactor: MovieDetailInteractorStub(),
                    id: 1285
                )
            )
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
