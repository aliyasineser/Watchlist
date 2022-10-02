//
//  TVSerieDetailView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import SwiftUI

struct TVSerieDetailView: View {

    @ObservedObject var presenter: TVSerieDetailDefaultPresenter
    @State var isFavorite = false

    init(presenter: TVSerieDetailDefaultPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
    }

    fileprivate func mediaView() -> some View {
        HStack(alignment: .top) {
            MediaHeaderView(imageUrl: presenter.media.posterUrl())
            VStack(alignment: .leading) {
                MediaDetailsView(
                    title: presenter.media.title,
                    genres: presenter.media.genres.first?.name,
                    rating: presenter.media.voteAverage,
                    language: presenter.media.originalLanguage,
                    date: presenter.media.firstAirDate,
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
            .padding(.trailing, 15)
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
            presenter: TVSerieDetailDefaultPresenter(
                interactor: TVSerieDetailInteractorStub(),
                id: 0
            )
        )
    }
}
