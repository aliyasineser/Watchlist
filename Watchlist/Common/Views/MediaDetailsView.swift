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
    var rating: Double?
    var language: OriginalLanguage?
    var date: Date
    var time: String?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 25))
                .bold()
                .minimumScaleFactor(0.65)
                .lineLimit(2)
                .padding(.bottom, 2)

            if let genres {
                Text(genres)
                    .font(.system(size: 17))
                    .foregroundColor(.primary)
                    .bold()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }

            if let rating {
                StarsView(rating: CGFloat(rating/2.0), maxRating: 5)
                    .frame(width: 120, alignment: .center)
            }

            if let language {
                Text(language.language)
                    .font(.system(size: 18))
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            Text(date.formatted(date: .abbreviated, time: .omitted))
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
            language: .en,
            date: .distantPast
        )
    }
}
