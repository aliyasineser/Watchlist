//
//  ArtistDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import Kingfisher

struct ArtistDetailView: View {

    @ObservedObject var presenter: ArtistDetailDefaultPresenter
    var artistId: Int

    @State var isFavorite = false

    init(artistId: Int, presenter: ArtistDetailDefaultPresenter) {
        self.presenter = presenter
        self.artistId = artistId
    }

    var body: some View {
        ScrollView(.vertical) {
            if let artist = self.presenter.artistDetail {
                ZStack {
                    artistImage(url: artist.getPosterUrl())
                    gradientView()
                }
                .frame(height: 200)
                VStack(alignment: .center, spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        artistInfoView(
                            name: artist.name,
                            birthday: artist.birthday
                        )
                        .padding(.leading, 30)
                        .padding(.bottom, 20)
                        HStack {
                            Spacer()
                            VStack {
                                FavoriteButton(
                                    favoriteStorage: presenter.favoriteStorage,
                                    isFavorite: $isFavorite,
                                    id: artist.id,
                                    title: artist.name
                                )
                                Spacer()
                            }
                            .padding(.trailing, 30)
                            .padding(.top, 20)
                        }
                    }

                    PhotoGrid(presenter: self.presenter)
                        .frame(height: 150)
                        .padding(.horizontal)

                    ArtistDetailTabView(
                        artistDetail: artist,
                        artistMovieCredits: self.presenter.artistMovieCredits,
                        artistTVSerieCredits: self.presenter.artistTVSerieCredits
                    )
                    .padding(10)
                }
            }
        }
        .onAppear(perform: {
            self.presenter.fetchArtist(artistId: artistId)
        })
    }

    fileprivate func artistImage(url: String) -> some View {
        return KFImage(URL(string: url))
            .resizable()
            .scaledToFill()
    }

    fileprivate func gradientView() -> some View {
        return Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .accentColor.opacity(0.01), location: 0),
                    .init(color: .accentColor.opacity(0.8), location: 1)
                ]),
                               startPoint: .top,
                               endPoint: .bottom
                )
            )
            .frame(maxWidth: .infinity)
    }

    fileprivate func artistInfoView(name: String, birthday: String?) -> some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.system(size: 30))
                .bold()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            if let birthday = birthday {
                Text(birthday)
                    .font(.system(size: 16))
                    .bold()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
    }

}

struct PhotoGrid: View {

    @ObservedObject var presenter: ArtistDetailDefaultPresenter

    init(presenter: ArtistDetailDefaultPresenter) {
        self.presenter = presenter
    }

    var body: some View {

        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                LazyHStack(spacing: 10) {
                    ForEach(
                        self.presenter.artistImages.reversed(),
                        id: \.filePath
                    ) { imageEntity in
                        artistImageItem(imageEntity)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    fileprivate func artistImageItem(_ imageEntity: Profile) -> some View {
        return KFImage(URL(string: imageEntity.getPosterUrl()))
            .resizable()
            .scaledToFill()
            .clipped()
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistDetailView(
                artistId: 21,
                presenter: ArtistDetailDefaultPresenter(
                    interactor: ArtistDetailInteractorStub()
                )
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
