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
                systemName: isFavorite ? Icons.Favorite.favorite.rawValue : Icons.Favorite.notFavorite.rawValue
            )
            .font(.title3.weight(.semibold))
            .foregroundStyle(Color.accentColor)
            .frame(width: 48, height: 48)
            .background(Color.accentColor.opacity(0.12), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove \(title) from favorites" : "Add \(title) to favorites")
        .accessibilityValue(isFavorite ? "Saved" : "Not saved")
        .sensoryFeedback(.selection, trigger: isFavorite)
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
