//
//  ArtistItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import SwiftUI
import CachedAsyncImage

struct ArtistItemView: View {

    private var artistEntity: ArtistEntity

    internal init(artistEntity: ArtistEntity) {
        self.artistEntity = artistEntity
    }

    fileprivate func artistImage() -> some View {
        return CachedAsyncImage(
            url: URL(string: self.artistEntity.imageUrl),
            content: { image in
                image.resizable()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
        )
        .scaledToFill()
        .frame(width: 105, height: 160)
        .clipped()
    }

    fileprivate func artistLabel() -> some View {
        return Text(self.artistEntity.name)
            .font(.system(size: 15))
            .foregroundColor(.primary)
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .padding(EdgeInsets(
                top: 4,
                leading: 2,
                bottom: 4,
                trailing: 2)
            )
    }

    var body: some View {
        VStack(alignment: .center) {
            artistImage()
            artistLabel()
        }
        .frame(width: 105, height: 190)
        .border(Color.primary, width: 1)
    }
}

struct ArtistItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ArtistItemView(artistEntity: ArtistEntity.mock)
        }
        .padding()
    }
}
