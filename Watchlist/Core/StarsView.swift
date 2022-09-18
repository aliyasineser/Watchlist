//
//  StarsView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

struct StarsView: View {
    private let rating: CGFloat
    private let maxRating: Int

    init(rating: CGFloat, maxRating: Int) {
        self.rating = rating
        self.maxRating = maxRating
    }

    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }

        stars.overlay(
            GeometryReader { geometry in
                let width = rating / CGFloat(maxRating) * geometry.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
                .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

struct StarsView_Previews: PreviewProvider {
    static var previews: some View {
        StarsView(rating: 3.8, maxRating: 5)
    }
}
