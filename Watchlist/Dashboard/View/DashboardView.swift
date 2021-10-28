//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI
import TMDBSwift

struct DashboardView: View {
    var body: some View {
    
        TabView {
            DiscoverView(presenter: DiscoverPresenter(DiscoverInteractor()))
            .tabItem {
                VStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Discover")
                }
            }
            .tag(0)
        
            GenresView(GenresPresenter(GenresInteractor()))
            .tabItem {
                VStack {
                    Image(systemName: "paintpalette.fill")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Genres")
                }
            }
            .tag(1)
        
            ArtistsView(presenter: ArtistPresenter(ArtistInteractor()))
            .tabItem {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .renderingMode(.template)
                        .foregroundColor(.teal)
                    Text("Artists")
                }
            }
            .tag(2)
        }
        .navigationBarTitle("Dashboard")
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        

    }
    
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
