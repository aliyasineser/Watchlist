//
//  FavoritesView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 24.09.2022.
//

import SwiftUI

struct FavoritesView: View {
    private let presenter: FavoritesPresenter

    init(presenter: FavoritesPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        VStack {
            Text("TODO: Implement the screen")
        }
        .navigationTitle(ConstantTexts.NavigationBarTitle.favoritesScreen)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FavoritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesView(
            presenter: FavoritesPresenter(
                DefaultFavoritesInteractor()
            )
        )
    }
}
