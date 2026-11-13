//
//  ArtistsView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI

struct ArtistsView: View {

    @State var presenter: ArtistDefaultPresenter
    @State private var position = 0

    let columns = [
        GridItem(.adaptive(minimum: 120))
    ]

    init(presenter: ArtistDefaultPresenter) {
        self.presenter = presenter
        // Spacer manages lading the artists, no need to call
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: true) {
                ScrollViewReader { proxy in
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        ForEach(self.presenter.artists, id: \.id) { (artist) in
                            NavigationLink(
                                destination: ArtistDetailView(
                                    artistId: artist.id,
                                    presenter: ArtistDetailDefaultPresenter(
                                        interactor: DefaultArtistDetailInteractor()
                                    )
                                )
                            ) {
                                ArtistItemView(artist: artist)
                            }
                        }
                        Spacer()
                            .task {
                                await presenter.loadArtists()
                            }
                    }.onChange(of: position) {
                        withAnimation {
                            proxy.scrollTo(150, anchor: .center)
                        }
                    }
                }
            }
            .navigationTitle(ConstantTexts.NavigationBarTitle.artistsScreen)
            .toolbar(.visible, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(
                EdgeInsets(
                    top: 15,
                    leading: 0,
                    bottom: 0,
                    trailing: 0)
            )
        }
        .errorAlert(error: $presenter.fetchError)
    }
}

struct ArtistsView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistsView(
            presenter: ArtistDefaultPresenter(
                ArtistInteractorStub()
            )
        )
    }
}
