//
//  MediaListView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

@MainActor
struct MediaListView: View {

    @ObservedObject var presenter: MediaListDefaultPresenter

    init(mediaListPresenter: MediaListDefaultPresenter) {
        self.presenter = mediaListPresenter
        self.presenter.fetchMedia()
    }

    var body: some View {

        ScrollView {
            LazyVStack(alignment: .center, spacing: 10) {
                ForEach(self.presenter.mediaList, id: \.id) { media in
                    MediaListItemView(mediaListItem: media)
                        .padding(.horizontal)
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.fetchMedia()
                    })
            }

        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView(
            mediaListPresenter: MediaListDefaultPresenter(
                MediaInteractorStub(),
                section: .comingSoonMovies
            )
        )
    }
}
