//
//  SimilarMediaView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import SwiftUI

struct SimilarMediaView: View {

    @State var presenter: MediaSimilarDefaultPresenter

    init(presenter: MediaSimilarDefaultPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .center, spacing: 10) {
                ForEach(self.presenter.media, id: \.id) { media in
                    MediaListItemView(mediaListItem: media)
                        .padding(.horizontal)
                }
                Spacer()
                    .task {
                        await presenter.fetchSimilar()
                    }
            }

        }
        .errorAlert(error: $presenter.fetchError)
    }
}

struct SimilarMediaView_Previews: PreviewProvider {
    static var previews: some View {
        SimilarMediaView(
            presenter: MediaSimilarDefaultPresenter(
                interactor: MediaSimilarInteractorStub(),
                id: 1
            )
        )
    }
}
