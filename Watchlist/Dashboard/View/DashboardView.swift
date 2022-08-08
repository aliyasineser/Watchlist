//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        TabView {
            DiscoverView(presenter: DiscoverPresenter(DiscoverInteractor()))
                .tabItem {
                    TabItemView(systemName: "square.grid.2x2.fill", text: ConstantTexts.discoverScreenTabBarItemText)
                }
                .tag(0)

            ArtistsView(presenter: ArtistPresenter(ArtistInteractor()))
                .tabItem {
                    TabItemView(systemName: "person.crop.circle", text: ConstantTexts.artistsScreenTabBarItemText)
                }
                .tag(1)
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
