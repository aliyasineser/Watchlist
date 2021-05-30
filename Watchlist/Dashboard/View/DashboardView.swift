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
        
        NavigationView{

            TabView {
                DiscoverView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "square.grid.2x2.fill")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Discover")
                    }.onAppear(perform: {
                        self.navTitle = "Discover"
                    })

                GenresView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "paintpalette.fill")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Genres")
                    }.onAppear(perform: {
                        self.navTitle = "Genres"
                    })

                ArtistsView()
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                            .renderingMode(.template)
                            .foregroundColor(.teal)
                        Text("Artists")
                    }.onAppear(perform: {
                        self.navTitle = "Artists"
                        
                    })
            }

        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(self.navTitle)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
