//
//  ArtistsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct MediaCastView: View {
    
    private var interactor: MediaCastInteractor
    @ObservedObject var presenter: MovieCastPresenter
    
    let columns = [
            GridItem(.adaptive(minimum: 100))
        ]
    
    init() {
        self.interactor = MediaCastInteractor()
        self.presenter = MovieCastPresenter(self.interactor)
        
        presenter.loadArtists()
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.artists) { (artist) in
                    
                    NavigationLink(destination: ArtistDetailView(artistId: artist.artistId)) {
                        ArtistItemView(id: artist.artistId, imageUrl: artist.imageUrl, name: artist.name)
                    }
                    
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.loadArtists()
                })
            }
        }
        .navigationBarTitle("Artists", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .background(Color.veryLightPink)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        
    }
}

struct MovieCastView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaCastView()
                .background(Color.veryLightPink)
        }
    }
}
