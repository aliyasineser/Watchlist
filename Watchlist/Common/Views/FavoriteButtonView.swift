//
//  FavoriteButtonView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.09.2022.
//

import Foundation
import SwiftUI

struct FavoriteButton: View {
    var favoriteStorage: FavoriteStorage
    @Binding var isFavorite: Bool
    var id: Int
    var title: String

    var body: some View {
        Button {
            if isFavorite {
                favoriteStorage.deleteFavorite(id: id)
            } else {
                favoriteStorage.addFavorite(
                    id: id,
                    name: title
                )
            }
            isFavorite = favoriteStorage.isFavorite(id: id)
        } label: {
            Image(
                systemName: isFavorite ? "star.fill": "star"
            )
            .foregroundColor(.accentColor)
        }
        .onAppear {
            isFavorite = favoriteStorage.isFavorite(id: id)
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            FavoriteButton(
                favoriteStorage: FavoriteStorageStub(),
                isFavorite: .constant(true),
                id: 1,
                title: "Title"
            )
            FavoriteButton(
                favoriteStorage: FavoriteStorageStub(),
                isFavorite: .constant(false),
                id: 1,
                title: "Title"
            )
        }
    }
}
