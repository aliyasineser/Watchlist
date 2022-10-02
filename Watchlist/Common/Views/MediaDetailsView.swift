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
    var date: Date?
    var time: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.title)
                .bold()
                .minimumScaleFactor(0.65)

            if let genres {
                Text(genres)
                    .font(.title2)
                    .foregroundColor(.primary)
                    .bold()
                    .minimumScaleFactor(0.7)
            }

            if let rating {
                StarsView(rating: CGFloat(rating/2.0), maxRating: 5)
                    .frame(width: 120, alignment: .center)
            }

            if let language {
                Text(language.language)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }
            if let date {
                Text(date.formatted(date: .abbreviated, time: .omitted))
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
            }

            
            if let time = time {
                Text(time)
                    .font(.title3)
                    .bold()
                    .foregroundColor(.primary)
                    .minimumScaleFactor(0.8)
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
