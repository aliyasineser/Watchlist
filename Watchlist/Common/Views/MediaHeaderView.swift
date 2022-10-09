//
//  MediaHeaderView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 26.09.2022.
//

import SwiftUI
import Kingfisher

struct MediaHeaderView: View {
    var imageUrl: String
    var body: some View {
        KFImage(URL(string: imageUrl))
            .resizable()
            .scaledToFill()
            .clipped()
    }
}

struct MediaHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MediaHeaderView(imageUrl: "")
    }
}
