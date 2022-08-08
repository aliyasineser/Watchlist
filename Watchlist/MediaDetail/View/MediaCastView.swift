//
//  ArtistsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct MediaCastView: View {

    @ObservedObject var presenter: MediaCastPresenter

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    init(presenter: MediaCastPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.artists) { (artist) in
                    NavigationLink(destination: ArtistDetailView(artistId: artist.id)) {
                        ArtistItemView(artistEntity: ArtistEntity(artistId: artist.id,
                                                                  imageUrl: artist.imageUrl, name: artist.name))
                    }
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.loadArtists()
                    })
            }
        }
        .navigationBarTitle(ConstantTexts.artistsScreenNavBarTitle, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 0))

    }
}

struct MovieCastView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaCastView(presenter: MediaCastPresenter(MediaCastInteractor(), id: 1, mediaType: .movie))
        }
    }
}
