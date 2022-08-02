//
//  MovieListItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

struct MovieListItemView: View {
    
    var movieListItem: MovieListItemEntity
    
    internal init(movieListItem: MovieListItemEntity) {
        self.movieListItem = movieListItem
    }
    
    var body: some View {
        
        NavigationLink(destination: MediaDetailView(presenter:  MediaDetailPresenter(interactor: MediaDetailInteractor(), movieId: self.movieListItem.id, mediaType: self.movieListItem.mediaType))) {
            VStack(alignment: .center, spacing: 5) {
                
                AsyncImage(
                    url: URL(string: self.movieListItem.imgUrl),
                    content: { image in
                        image.resizable()
                            .scaledToFill()
                            .frame(height: 210)
                            .clipped()
                    },
                    placeholder: {
                        CommonMocks.posterPlaceholder
                            .resizable()
                            .scaledToFill()
                            .frame(height: 210)
                            .clipped()
                    }
                )
                
                HStack {
                    VStack {
                        Text(self.movieListItem.title)
                            .font(.system(size: 20))
                            .bold()
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.8)
                        Text(self.movieListItem.genres)
                            .font(.system(size: 14))
                            .bold()
                            .foregroundColor(.primary)
                            .minimumScaleFactor(0.8)
                    }
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    Spacer()
                    StarsView(rating: CGFloat(self.movieListItem.rating), maxRating: 5)
                        .frame(width: 100, alignment: .center)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
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
        MovieListItemView(movieListItem: MovieMocks.movieListItem)
    }
}
