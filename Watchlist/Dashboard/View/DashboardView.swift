//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI

enum TabViewSection: Hashable {
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
    @State private var selectedTab: TabViewSection = .discover
    @State private var discoverPresenter: DiscoverDefaultPresenter
    @State private var artistPresenter: ArtistDefaultPresenter
    @State private var favoritesPresenter: FavoritesDefaultPresenter

    init(dependencies: AppDependencies = AppDependenciesImpl()) {
        _discoverPresenter = State(initialValue: dependencies.makeDiscoverPresenter())
        _artistPresenter = State(initialValue: dependencies.makeArtistPresenter())
        _favoritesPresenter = State(initialValue: dependencies.makeFavoritesPresenter())
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Discover", systemImage: Icons.TabBar.discover.rawValue, value: .discover) {
                DiscoverView(presenter: discoverPresenter)
            }
            Tab("Artists", systemImage: Icons.TabBar.artist.rawValue, value: .artists) {
                ArtistsView(presenter: artistPresenter)
            }
            Tab("Favorites", systemImage: Icons.TabBar.favorites.rawValue, value: .favorites) {
                FavoritesView(presenter: favoritesPresenter)
            }
        }
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
