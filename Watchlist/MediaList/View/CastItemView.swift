//
//  CastItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI

struct CastItemView: View {

    private var castEntity: CastEntity

    internal init(castEntity: CastEntity) {
        self.castEntity = castEntity
    }

    fileprivate func castImage() -> some View {
        return AsyncImage(
            url: URL(string: self.castEntity.imageUrl),
            content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .clipped()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 120)
                    .clipped()
            }
        )
    }

    fileprivate func castName() -> some View {
        return Text(self.castEntity.name)
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
        return Text(self.castEntity.character)
            .font(.system(size: 13))
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

    var body: some View {
        VStack(alignment: .center) {
            castImage()
            castName()
            castRole()
        }
        .frame(width: 100, height: 175)
        .border(
            Color.primary,
            width: 1
        )
    }
}

struct CastItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CastItemView(castEntity: CastEntity.mock)
        }
        .padding()
    }
}
