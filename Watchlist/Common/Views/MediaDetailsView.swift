//
//  MediaDetailsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.09.2022.
//

import SwiftUI

struct MediaDetailsView: View {
    var title: String
    var genres: String?
    var rating: CGFloat
    var language: String
    var date: String
    var time: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 25))
                .bold()
                .minimumScaleFactor(0.65)
                .lineLimit(2)
                .padding(.bottom, 2)

            if let genres = genres {
                Text(genres)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .bold()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }

            RatingView(rating: rating)

            if let lang = OriginalLanguage(isoCode: language)?.language {
                Text(lang)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            Text(date)
                .font(.system(size: 17))
                .bold()
                .foregroundColor(.primary)
                .minimumScaleFactor(0.8)
                .lineLimit(1)
                .padding(.top, 3)

            if let time = time {
                Text(time)
                    .font(.system(size: 17))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .padding(.top, 3)
                    .padding(.bottom, 5)
            }
        }
    }
}

struct MediaDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailsView(
            title: "Title",
            rating: 5.5,
            language: "English",
            date: "24-05-1588"
        )
    }
}