//
//  TVSerieDetailView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import SwiftUI
import CachedAsyncImage

struct TVSerieDetailView: View {

    @ObservedObject var presenter: TVSerieDetailPresenter
    let favoriteStorage: FavoriteStorage
    @State var isFavorite = false

    init(presenter: TVSerieDetailPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
        favoriteStorage = FavoriteTVSerieStorage.shared
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

                FavoriteButton(favoriteStorage: favoriteStorage,
                               isFavorite: $isFavorite,
                               id: presenter.id,
                               title: presenter.media.title
                )

            }
            .padding(.leading, 5)
            Spacer()
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        PosterView(imageUrl: presenter.media.imagePath, height: 300, width: geometry.size.width)
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
                            mediaService: TVService.shared
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

struct TVSerieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVSerieDetailView(
            presenter: TVSerieDetailPresenter(
                interactor: TVSerieDetailInteractorStub(),
                id: 0
            )
        )
    }
}
