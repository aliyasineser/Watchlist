//
//  CastView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI

struct CastView: View {
    @ObservedObject private var presenter: CastPresenter

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    init(presenter: CastPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.artists) { (artist) -> CastItemView in
                    CastItemView(
                        castEntity: CastEntity(
                            imageUrl: artist.imageUrl,
                            name: artist.name,
                            character: artist.character
                        )
                    )
                }
                Spacer()
                    .onAppear(perform: {
                        presenter.loadArtists()
                    })
            }
        }
        .onAppear(perform: {
            presenter.loadArtists()
        })
        .padding(
            EdgeInsets(
                top: 15,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        )

    }
}

struct CastView_Previews: PreviewProvider {
    static var previews: some View {
        CastView(
            presenter: CastPresenter(
                CastInteractorStub(),
                id: 5
            )
        )
    }
}
