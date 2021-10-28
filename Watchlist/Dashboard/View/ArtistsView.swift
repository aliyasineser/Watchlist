//
//  ArtistsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct ArtistsView: View {
    
    
    @ObservedObject var presenter: ArtistPresenter
    @State private var position = 0
    
    let columns = [
            GridItem(.adaptive(minimum: 120))
        ]
    
    init(presenter: ArtistPresenter) {
        
        self.presenter = presenter
        
        presenter.loadArtists()
    }
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: true) {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        ForEach(self.presenter.artists, id:\.id) { (artist) in
                            NavigationLink(destination: ArtistDetailView(artistId: artist.artistId)) {
                                ArtistItemView(id: artist.artistId, imageUrl: artist.imageUrl, name: artist.name)
                            }
                        }
                        Spacer() // Spacer is at the and invisible, when we "see" it we load more.
                        .onAppear(perform: {
                                presenter.loadArtists()
                        })
                    }.onChange(of: position) { value in
                        withAnimation {
                            proxy.scrollTo(150, anchor: .center)
                        }
                    }
                }
            }
            .navigationBarTitle("Artists")
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))
        }
        
    }
}


struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(presenter: ArtistPresenter(ArtistInteractor()))
    }
}
