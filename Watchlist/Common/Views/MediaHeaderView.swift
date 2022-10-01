//
//  MediaHeaderView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.09.2022.
//

import SwiftUI
import CachedAsyncImage

struct MediaHeaderView: View {
    var imageUrl: String
    var body: some View {
        CachedAsyncImage(
            url: URL(string: imageUrl),
            content: { image in
                image.resizable()
                    .scaledToFill()
                    .clipped()
            },
            placeholder: {
                Image(systemName: Icons.posterBackdrop.rawValue)
                    .scaledToFill()
                    .clipped()
            }
        )

    }
}

struct MediaHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MediaHeaderView(imageUrl: "")
    }
}
