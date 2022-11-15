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
    case auth

    var tag: Int {
        switch self {
        case .discover:
            return 0
        case .artists:
            return 1
        case .favorites:
            return 2
        case .auth:
            return 3
        }
    }
}

struct DashboardView: View {
    @State var selectedTabIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            DiscoverView(
                presenter: DiscoverDefaultPresenter(
                    DefaultMediaInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: Icons.TabBar.discover.rawValue,
                    text: ConstantTexts.TabBarItemTitle.discoverScreen
                )
            }
            .tag(TabViewSection.discover.tag)

            ArtistsView(
                presenter: ArtistDefaultPresenter(
                    DefaultArtistInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: Icons.TabBar.artist.rawValue,
                    text: ConstantTexts.TabBarItemTitle.artistsScreen
                )
            }
            .tag(TabViewSection.artists.tag)

            FavoritesView(
                presenter: FavoritesDefaultPresenter(
                    DefaultFavoritesInteractor()
                )
            )
            .tabItem {
                TabItemView(
                    systemName: Icons.TabBar.favorites.rawValue,
                    text: ConstantTexts.TabBarItemTitle.favoritesScreen
                )
            }
            .tag(TabViewSection.favorites.tag)

            AuthWebView()
            .tabItem {
                TabItemView(
                    systemName: "person.fill.checkmark.rtl",
                    text: "Auth"
                )
            }
            .tag(TabViewSection.auth.tag)
        }
        .navigationBarTitle(ConstantTexts.NavigationBarTitle.dashboardScreen)
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
