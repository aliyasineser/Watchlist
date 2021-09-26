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
                ForEach(self.presenter.artists) { (artist) in
                    NavigationLink(destination: ArtistDetailView(artistId: artist.artistId)){
                        ArtistItemView(id: artist.artistId, imageUrl: artist.imageUrl, name: artist.name)
                    }
                }
                Spacer() // Spacer is at the and invisible, when we "see" it we load more.
                .onAppear(perform: {
                        presenter.loadArtists()
                })
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView()
    }
}
