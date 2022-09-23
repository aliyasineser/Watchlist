//
//  MediaDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 5.07.2021.
//

import SwiftUI
import CachedAsyncImage

struct MediaDetailView: View {

    @ObservedObject var presenter: MediaDetailPresenter
    let favoriteStorage: FavoriteStorage
    @State var isFavorite = false

    init(presenter: MediaDetailPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
        favoriteStorage = presenter.mediaType == .movie ? FavoriteMovieStorage.shared: FavoriteTVSerieStorage.shared
    }

    fileprivate func mediaTitle() -> some View {
        return Text(presenter.media.title)
            .font(.system(size: 25))
            .bold()
            .minimumScaleFactor(0.65)
            .lineLimit(2)
            .padding(.bottom, 2)
    }

    fileprivate func rating() -> some View {
        return HStack {
            StarsView(rating: CGFloat(presenter.media.point/2.0), maxRating: 5)
                .frame(width: 110, alignment: .center)
            Text(String(format: "%.1f / 10", presenter.media.point))
                .font(.system(size: 14))
                .bold()
                .foregroundColor(.primary)
                .minimumScaleFactor(0.7)
                .clipped()
        }
    }

    fileprivate func releaseDate() -> some View {
        return Text(presenter.media.date)
            .font(.system(size: 17))
            .bold()
            .foregroundColor(.primary)
            .minimumScaleFactor(0.8)
            .lineLimit(1)
            .padding(.top, 3)
    }

    fileprivate func mediaDetailStack() -> some View {
        return VStack(alignment: .leading) {
            mediaTitle()

            if let genres = presenter.media.genres {
                Text(genres)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .bold()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }

            rating()

            if let lang = OriginalLanguage(isoCode: presenter.media.language)?.language {
                Text(lang)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            releaseDate()

            if let time = presenter.media.time {
                Text(time)
                    .font(.system(size: 17))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .padding(.top, 3)
                    .padding(.bottom, 5)
            }

            Button {
                if isFavorite {
                    favoriteStorage.deleteFavorite(id: presenter.mediaId)
                } else {
                    favoriteStorage.addFavorite(
                        id: presenter.mediaId,
                        name: presenter.media.title
                    )
                }
                isFavorite = favoriteStorage.isFavorite(id: presenter.mediaId)
            } label: {
                Image(
                    systemName: isFavorite ? "star.fill": "star"
                )
                .foregroundColor(.teal)
            }
            .onAppear {
                isFavorite = favoriteStorage.isFavorite(id: presenter.mediaId)
            }

        }
    }

    fileprivate func mediaView() -> some View {
        return HStack(alignment: .top) {
            CachedAsyncImage(
                url: URL(string: presenter.media.imagePath),
                content: { image in
                    image.resizable()
                        .scaledToFill()
                        .clipped()
                },
                placeholder: {
                    Image(systemName: "film")
                        .scaledToFill()
                        .clipped()
                }
            )

            mediaDetailStack()
                .padding(.leading, 5)
            Spacer()
        }
    }

    fileprivate func mediaPoster(geometry: GeometryProxy) -> some View {
        return ZStack(alignment: .bottom) {
            CachedAsyncImage(
                url: URL(string: presenter.media.imagePath),
                content: { image in
                    image.resizable()
                },
                placeholder: {
                    Image(systemName: "film")
                }
            )
            .scaledToFill()
            .frame(height: 300)
            .clipped()

            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                        .init(color: Color(UIColor.systemBackground), location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
                .frame(height: 0.3 * geometry.size.width)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        mediaPoster(geometry: geometry)
                            .frame(width: geometry.size.width, height: 300, alignment: .center)

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
                            self.presenter.mediaId,
                            mediaType: self.presenter.mediaType
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

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaDetailView(
                presenter: MediaDetailPresenter(
                    interactor: MediaDetailInteractorStub(),
                    movieId: 1285,
                    mediaType: .movie
                )
            )
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
