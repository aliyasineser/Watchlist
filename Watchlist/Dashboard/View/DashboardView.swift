//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI
import TMDBSwift

enum Tabs: String {
    case discover = "Discover"
    case genres = "Genres"
    case artists = "Artists"
}

struct DashboardView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var navTitle: String = ""
    @State var selectedTab: Tabs = .discover
    private var presenter = DashboardPresenter()
    
    var body: some View {
    
        TabView(selection: $selectedTab) {
            DiscoverView()
                .onAppear {
                    self.navTitle = "Discover"
                }
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Discover")
                }
                .tag(Tabs.discover)
        
            GenresView()
                .onAppear {
                    self.navTitle = "Genres"
                }
                .tabItem {
                    Image(systemName: "paintpalette.fill")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Genres")
                }
                .tag(Tabs.genres)
        
            ArtistsView()
                .onAppear {
                    self.navTitle = "Artists"
                }
                .tabItem {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Artists")
                }
                .tag(Tabs.artists)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(selectedTab.rawValue)

    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
