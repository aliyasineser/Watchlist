//
//  MediaListItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI
import CachedAsyncImage

struct MediaListItemView: View {

    var mediaListItem: Watchable

    internal init(mediaListItem: Watchable) {
        self.mediaListItem = mediaListItem
    }

    fileprivate func posterImage() -> some View {
        return CachedAsyncImage(
            url: URL(string: self.mediaListItem.posterUrl()),
            content: { image in
                image.resizable()
                    .scaledToFill()
            },
            placeholder: {
                Image(systemName: "film")
                    .imageScale(.large)
            }
        )
        .frame(height: 210)
        .clipped()
    }

    fileprivate func movieInfoStack() -> some View {
        return HStack {
            VStack {
                Text(self.mediaListItem.title)
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 10,
                    bottom: 0,
                    trailing: 0
                )
            )
            Spacer()
            if let rating = self.mediaListItem.voteAverage {
                StarsView(rating: CGFloat(rating), maxRating: 5)
                    .frame(width: 100, alignment: .center)
                    .padding(
                        EdgeInsets(
                            top: 0,
                            leading: 0,
                            bottom: 0,
                            trailing: 10
                        )
                    )
            }
        }
    }

    @MainActor
    func getMediaDetailView(mediaType: Watchable.Type) -> some View {
        VStack {
            if (mediaType as? Movie.Type) != nil {
                MovieDetailView(
                    presenter: MovieDetailPresenter(
                        interactor: DefaultMovieDetailInteractor(),
                        id: self.mediaListItem.id
                    )
                )
            } else {
                TVSerieDetailView(
                    presenter: TVSerieDetailPresenter(
                        interactor: DefaultTVSerieDetailInteractor(),
                        id: self.mediaListItem.id
                    )
                )
            }
        }
    }

    var body: some View {
        NavigationLink(
            destination:
                getMediaDetailView(mediaType: type(of: mediaListItem))
        ) {
            VStack(alignment: .center, spacing: 5) {
                posterImage()
                movieInfoStack()
            }
            .frame(width: 400, height: 250)
            .cornerRadius(10)
            .shadow(
                color: Color.black.opacity(0.2),
                radius: 20,
                x: 0,
                y: 0
            )
        }
    }
}

struct MediaListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListItemView(mediaListItem: Movie.mock)
    }
}
