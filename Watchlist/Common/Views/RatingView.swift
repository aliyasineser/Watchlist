//
//  RatingView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.09.2022.
//

import SwiftUI

struct RatingView: View {
    var rating: Double
    var maxRating: Int = 5

    var body: some View {
        HStack {
            StarsView(rating: CGFloat(rating/2.0), maxRating: maxRating)
                .frame(width: 110, alignment: .center)
            Text(String(format: "%.1f / 10", rating))
                .font(.system(size: 14))
                .bold()
                .foregroundColor(.primary)
                .minimumScaleFactor(0.7)
                .clipped()
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: 7.3)
    }
}
