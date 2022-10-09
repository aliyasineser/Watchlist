//
//  CastItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI
import Kingfisher

struct CastItemView: View {

    private var cast: Cast

    internal init(cast: Cast) {
        self.cast = cast
    }

    fileprivate func castImage() -> some View {
        return KFImage(URL(string: cast.getPosterUrl()))
            .resizable()
                .scaledToFill()
                .frame(width: 100, height: 150)
                .clipped()
    }

    fileprivate func castName() -> some View {
        return Text(cast.getTitle())
            .font(.system(size: 15))
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 2,
                    bottom: 4,
                    trailing: 2
                )
            )
    }

    fileprivate func castRole() -> some View {
        return Text(cast.getRole())
            .font(.system(size: 13))
            .fontWeight(.regular)
            .multilineTextAlignment(.center)
            .truncationMode(.tail)
            .lineLimit(2)
            .minimumScaleFactor(0.7)
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 2,
                    bottom: 4,
                    trailing: 2
                )
            )
    }

    var body: some View {
        VStack(alignment: .center) {
            castImage()
            castName()
            castRole()
        }
        .frame(width: 100)
        .border(
            Color.primary,
            width: 1
        )
    }
}

struct CastItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CastItemView(cast: Cast.mock)
        }
        .padding()
    }
}
