//
//  ArtistsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct ArtistsView: View {
    
    private var interactor: ArtistInteractor
    @ObservedObject var presenter: ArtistPresenter
    
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    
    init() {
        self.interactor = ArtistInteractor()
        self.presenter = ArtistPresenter(self.interactor)
        
        presenter.loadArtists()
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.artists) { (artist) -> ArtistItemView in
                    ArtistItemView(imageUrl: artist.imageUrl, name: artist.name)
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.loadArtists()
                })
            }
        }
        .background(Color.veryLightPink)
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView()
            .background(Color.veryLightPink)
    }
}
