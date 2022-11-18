//
//  MediaListItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI
import Kingfisher

struct MediaListItemView: View {

    var mediaListItem: Watchable

    internal init(mediaListItem: Watchable) {
        self.mediaListItem = mediaListItem
    }

    fileprivate func posterImage() -> some View {
        KFImage(URL(string: self.mediaListItem.posterUrl))
            .resizable()
            .scaledToFit()
            .frame(height: 200)
            .clipped()
    }

    fileprivate func movieInfoStack() -> some View {
        return VStack(alignment: .leading, spacing: 5) {
            Text(self.mediaListItem.title)
                .font(.title)
                .minimumScaleFactor(0.7)
                .bold()
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)

            if let originalLanguage = self.mediaListItem.originalLanguage?.language {
                Text(originalLanguage)
                    .font(.title3)
                    .minimumScaleFactor(0.7)
                    .bold()
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
            }

            if let rating = self.mediaListItem.voteAverage {
                StarsView(rating: CGFloat(rating/2), maxRating: 5)
                    .frame(width: 100, alignment: .center)
            }
        }
    }

    @MainActor
    func getMediaDetailView(mediaType: Watchable.Type) -> some View {
        VStack {
            if (mediaType as? Movie.Type) != nil {
                MovieDetailView(
                    presenter: MovieDetailDefaultPresenter(
                        interactor: DefaultMovieDetailInteractor(),
                        id: self.mediaListItem.id
                    )
                )
            } else {
                TVSerieDetailView(
                    presenter: TVSerieDetailDefaultPresenter(
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
            HStack(alignment: .center, spacing: 15) {
                posterImage()
                movieInfoStack()
                Spacer()
            }
            .frame(height: 250)
            .cornerRadius(10)
        }
    }
}

struct MediaListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListItemView(mediaListItem: Movie.mock)
            .background(.red)
    }
}
