//
//  MediaListView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 13.06.2021.
//

import SwiftUI

@MainActor
struct MediaListView: View {

    @State var presenter: MediaListDefaultPresenter

    init(mediaListPresenter: MediaListDefaultPresenter) {
        self.presenter = mediaListPresenter
    }

    var body: some View {

        ScrollView {
            LazyVStack(alignment: .center, spacing: 16) {
                ForEach(self.presenter.mediaList, id: \.id) { media in
                    MediaListItemView(mediaListItem: media)
                        .padding(.horizontal, 20)
                }
                LoadStateView(
                    isLoading: presenter.isLoading,
                    hasContent: !presenter.mediaList.isEmpty,
                    hasMore: presenter.hasMore,
                    error: presenter.fetchError,
                    retry: { await presenter.fetchMedia() }
                )
            }
            .padding(.vertical, 20)
        }
        .background(Color(.systemGroupedBackground))
        .task { if presenter.mediaList.isEmpty { await presenter.fetchMedia() } }
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
