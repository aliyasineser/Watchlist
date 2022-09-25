//
//  MediaListView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

@MainActor
struct MediaListView: View {

    init(mediaListPresenter: MediaListPresenter) {
        self.presenter = mediaListPresenter
        self.presenter.fetchMedia()
    }

    var presenter: MediaListPresenter

    var body: some View {

        ScrollView {
            VStack(alignment: .center, spacing: 10) {
                ForEach(self.presenter.mediaList) { media in
                    MediaListItemView(mediaListItem: media)
                }
            }
        }
    }
}

struct MediaListView_Previews: PreviewProvider {
    static var previews: some View {
        MediaListView(
            mediaListPresenter: MediaListPresenter(
                MediaInteractorStub(),
                section: .comingSoonMovies
            )
        )
    }
}
