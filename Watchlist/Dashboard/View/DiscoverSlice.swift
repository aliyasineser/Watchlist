//
//  DiscoverSlice.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 1.06.2021.
//

import SwiftUI

struct DiscoverSlice: View {

    var sliceTitle: String
    var sliceItems: [Watchable]
    var section: MediaSection

    internal init(sliceTitle: String, sliceItems: [Watchable], section: MediaSection) {
        self.sliceTitle = sliceTitle
        self.sliceItems = sliceItems
        self.section = section
    }

    var seeAllView: some View {
        HStack(alignment: .bottom, spacing: 3) {
            Text(ConstantTexts.ButtonTitle.sliceSeeAll)
                .foregroundColor(.accentColor)
                .font(.title2)
                .bold()
            Image(systemName: Icons.seeAllButton.rawValue)
                .foregroundColor(.accentColor)
                .padding(.bottom, 4)
        }
        .padding(.trailing, 10)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Text(self.sliceTitle)
                    .font(.title)
                    .bold()
                Spacer()
                NavigationLink(
                    destination: MediaListView(
                        mediaListPresenter: MediaListDefaultPresenter(
                            DefaultMediaInteractor(),
                            section: self.section
                        )
                    )
                ) {
                    seeAllView
                }
            }
            .padding(.leading, 15)
            .padding(.trailing, 5)

            if sliceItems.isEmpty {
                ProgressView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(self.sliceItems, id: \.id) { item in
                            DiscoverSliceItem(item: item)
                                .frame(width: 140, height: 240, alignment: .center)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct DiscoverSlice_Previews: PreviewProvider {

    static var previews: some View {
        DiscoverSlice(
            sliceTitle: "Title",
            sliceItems: [Movie.mock,
                         Movie.mock,
                         Movie.mock,
                         Movie.mock,
                         Movie.mock,
                         Movie.mock,
                         Movie.mock,
                         Movie.mock
                        ],
            section: MediaSection.popularMovies
        )
    }
}
