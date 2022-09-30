//
//  CastView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI

struct CastView: View {
    @ObservedObject private var presenter: CastDefaultPresenter

    let columns = [
        GridItem(.adaptive(minimum: 100))
    ]

    init(presenter: CastDefaultPresenter) {
        self.presenter = presenter
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                ForEach(self.presenter.casts, id: \.id) { (artist) -> CastItemView in
                    CastItemView(
                        cast: artist
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
            presenter: CastDefaultPresenter(
                CastInteractorStub(),
                id: 5
            )
        )
    }
}
