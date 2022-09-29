//
//  ArtistDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import CachedAsyncImage

struct ArtistDetailView: View {

    @ObservedObject var presenter: ArtistDetailPresenter
    var artistId: Int

    let favoriteStorage: FavoriteStorage = FavoriteArtistStorage.shared
    @State var isFavorite = false

    init(artistId: Int, presenter: ArtistDetailPresenter) {
        self.presenter = presenter
        self.artistId = artistId
    }

    var body: some View {
        ScrollView(.vertical) {
            if let artist = self.presenter.artistDetail {
                ZStack {
                    artistImage(url: artist.getPosterUrl())
                    gradientView(height: 440)
                }
                VStack(spacing: 0) {
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
                                    favoriteStorage: favoriteStorage,
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

                    ArtistDetailTabView(artist, artistCredits: self.presenter.artistCredits)
                        .padding(10)
                }
            }
        }
        .onAppear(perform: {
            self.presenter.fetchArtist(artistId: artistId)
        })
    }

    fileprivate func artistImage(url: String) -> some View {
        return CachedAsyncImage(
            url: URL(string: url),
            content: { image in
                image.resizable()
                    .scaledToFill()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
            }
        )
    }

    fileprivate func gradientView(height: CGFloat = 200) -> some View {
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

    @ObservedObject var presenter: ArtistDetailPresenter

    init(presenter: ArtistDetailPresenter) {
        self.presenter = presenter
    }

    var body: some View {

        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                if presenter.artistImages.count > 1 {
                    ZStack {
                        artistGridImage()
                        Rectangle()
                            .foregroundColor(.accentColor)
                            .opacity(0.7)

                        numberOfImagesLabel()
                    }
                    .onTapGesture {
                        // Navigation to artist images
                    }
                    .cornerRadius(10)
                }

                LazyHStack(spacing: 10) {
                    ForEach(self.presenter.artistImages.reversed(), id: \.filePath) { imageEntity in
                        artistImageItem(imageEntity)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    fileprivate func artistGridImage() -> some View {
        CachedAsyncImage(
            url: URL(string: self.presenter.artistDetail?.getPosterUrl() ?? ""),
            content: { image in
                image.resizable()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
        )
        .scaledToFit()
    }

    fileprivate func numberOfImagesLabel() -> some View {
        VStack {
            Text("\(presenter.artistImages.count)\(presenter.artistImages.count > 1 ? "+" : "")")
                .font(.system(size: 25))
                .bold()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(ConstantTexts.ButtonTitle.artistDetailScreenPhotoAlbums)
                .font(.system(size: 16))
                .bold()
                .minimumScaleFactor(0.5)
        }
    }

    fileprivate func artistImageItem(_ imageEntity: ReversedCollection<[Profile]>.Element) -> some View {
        CachedAsyncImage(
            url: URL(string: imageEntity.getPosterUrl()),
            content: { image in
                image.resizable()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
        )
        .scaledToFill()
        .clipped()
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistDetailView(
                artistId: 21,
                presenter: ArtistDetailPresenter(
                    interactor: ArtistDetailInteractorStub()
                )
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
