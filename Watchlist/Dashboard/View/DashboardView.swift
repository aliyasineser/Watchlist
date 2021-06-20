//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI
import TMDBSwift

struct DashboardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var navTitle: String = ""
    @State private var selectedTab = 0
    private var presenter = DashboardPresenter()
    
    var body: some View {
        
        TabView {
            NavigationView {
                DiscoverView()
            }
            .tabItem {
                Image(systemName: "square.grid.2x2.fill")
                    .renderingMode(.template)
                    .foregroundColor(.teal)
                Text("Discover")
            }
            
            NavigationView {
                GenresView()
            }
            .tabItem {
                Image(systemName: "paintpalette.fill")
                    .renderingMode(.template)
                    .foregroundColor(.teal)
                Text("Genres")
            }
            
            NavigationView {
                ArtistsView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle")
                    .renderingMode(.template)
                    .foregroundColor(.teal)
                Text("Artists")
            }
            
        }
    
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
