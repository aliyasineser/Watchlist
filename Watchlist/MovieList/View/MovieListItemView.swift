//
//  MovieListItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

struct MovieListItemView: View {

    var mediaListItem: Media

    internal init(movieListItem: Media) {
        self.mediaListItem = movieListItem
    }

    var body: some View {
        NavigationLink(destination: MediaDetailView(presenter:
                                                        MediaDetailPresenter(interactor: MediaDetailInteractor(),
                                                                             movieId: self.mediaListItem.getID(),
                                                                             mediaType: mediaListItem.mediaType))) {
            VStack(alignment: .center, spacing: 5) {

                AsyncImage(
                    url: URL(string: self.mediaListItem.getPosterUrl()),
                    content: { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 210)
                            .clipped()
                    },
                    placeholder: {
                        CommonMocks.posterPlaceholder
                            .scaledToFill()
                            .frame(height: 210)
                            .clipped()
                    }
                )

                HStack {
                    VStack {
                        Text(self.mediaListItem.getTitle())
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    Spacer()
                    if let rating = self.mediaListItem.getVoteAverage() {
                        StarsView(rating: CGFloat(rating), maxRating: 5)
                            .frame(width: 100, alignment: .center)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }
                }
            }
            .frame(width: 400, height: 250)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
        }
    }
}

struct MovieListItemView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListItemView(movieListItem: MovieMocks.mediaStub)
    }
}
