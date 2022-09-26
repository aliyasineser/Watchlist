//
//  PosterView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation
import SwiftUI
import CachedAsyncImage

struct PosterView: View {
    var imageUrl: String

    var height: CGFloat
    var width: CGFloat

    var body: some View {
        ZStack(alignment: .bottom) {
            CachedAsyncImage(
                url: URL(string: imageUrl),
                content: { image in
                    image.resizable()
                },
                placeholder: {
                    Image(systemName: "film")
                }
            )
            .scaledToFill()
            .frame(width: width, height: height)
            .clipped()

            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                        .init(color: Color(UIColor.systemBackground), location: 1)
                    ]), startPoint: .top, endPoint: .bottom)
                )
                .frame(height: 0.3 * height)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct PosterView_Previews: PreviewProvider {
    static var previews: some View {
        PosterView(
            imageUrl: "",
            height: 300,
            width: 200
        )
        .border(width: 1, edges: Edge.allCases, color: .accentColor)
    }
}
