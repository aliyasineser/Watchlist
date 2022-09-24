//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI

enum TabViewSection {
    case discover
    case artists
    case favorites

    var tag: Int {
        switch self {
        case .discover:
            return 0
        case .artists:
            return 1
        case .favorites:
            return 2
        }
    }
}

struct DashboardView: View {
    var body: some View {
        TabView {
            DiscoverView(
                presenter: DiscoverPresenter(
                    DefaultMediaInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: "square.grid.2x2.fill",
                    text: ConstantTexts.discoverScreenTabBarItemText
                )
            }
            .tag(TabViewSection.discover.tag)

            ArtistsView(
                presenter: ArtistPresenter(
                    DefaultArtistInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: "person.crop.circle",
                    text: ConstantTexts.artistsScreenTabBarItemText
                )
            }
            .tag(TabViewSection.artists.tag)

            FavoritesView(
                presenter: FavoritesPresenter(
                    DefaultFavoritesInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: "star.circle.fill",
                    text: ConstantTexts.favoritesScreenTabBarItemText
                )
            }
            .tag(TabViewSection.favorites.tag)
        }
        .navigationBarTitle(ConstantTexts.dashboardScreenNavBarTitle)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TabItemView: View {

    private let systemName: String
    private let text: String

    init(systemName: String, text: String) {
        self.systemName = systemName
        self.text = text
    }

    var body: some View {
        VStack {
            Image(systemName: self.systemName)
                .renderingMode(.template)
                .foregroundColor(.teal)
            Text(self.text)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
