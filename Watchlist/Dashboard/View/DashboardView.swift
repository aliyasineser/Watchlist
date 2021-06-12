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
    private var presenter = DashboardPresenter()
    
    var body: some View {
        
        NavigationView {

            TabView {
                DiscoverView()
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Discover")
                    }.onAppear(perform: {
                        self.navTitle = "Discover"
                    })
                    .background(Color.veryLightPink)

                GenresView()
                    .tabItem {
                        Image(systemName: "paintpalette.fill")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Genres")
                    }.onAppear(perform: {
                        self.navTitle = "Genres"
                    })
                    .background(Color.veryLightPink)

                ArtistsView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Artists")
                    }.onAppear(perform: {
                        self.navTitle = "Artists"
                    })
                    .background(Color.veryLightPink)
            }
            .navigationTitle(self.navTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .navigationBarBackButtonHidden(true)
        
        
        
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
