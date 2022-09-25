//
//  DiscoverSlice.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 1.06.2021.
//

import SwiftUI

struct DiscoverSlice: View {

    var sliceTitle: String
    var sliceItems: [DiscoverSectionItemEntity]
    var section: MediaSection
    var type: MediaType

    internal init(sliceTitle: String, sliceItems: [DiscoverSectionItemEntity], section: MediaSection, type: MediaType) {
        self.sliceTitle = sliceTitle
        self.sliceItems = sliceItems
        self.section = section
        self.type = type
    }

    var seeAllView: some View {
        HStack(alignment: .center, spacing: 1.0) {
            Text(ConstantTexts.ButtonTitle.sliceSeeAll)
                .foregroundColor(.accentColor)
                .font(.system(size: 20))
                .bold()
            Image(systemName: "chevron.right")
                .foregroundColor(.accentColor)
                .padding(.bottom, 4)
        }.padding(.trailing, 10)
    }

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Text(self.sliceTitle)
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                NavigationLink(
                    destination: MediaListView(
                        mediaListPresenter: MediaListPresenter(
                            DefaultMediaInteractor(),
                            section: self.section
                        )
                    )
                ) {
                    seeAllView
                }
            }
            .padding(
                EdgeInsets(
                    top: 0,
                    leading: 15,
                    bottom: 0,
                    trailing: 5
                )
            )

            if sliceItems.isEmpty {
                ProgressView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 10) {
                        ForEach(self.sliceItems, id: \.itemID) { item in
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
        DiscoverSlice(sliceTitle: "Title",
                      sliceItems: [DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock,
                                   DiscoverSectionItemEntity.mock
                                  ],
                      section: MediaSection.popularMovies, type: .movie
        )
    }
}
