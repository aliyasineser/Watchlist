//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI

@MainActor
struct DiscoverSliceItem: View {

    var item: DiscoverSectionItemEntity

    init(item: DiscoverSectionItemEntity) {
        self.item = item
    }

    var body: some View {
        NavigationLink(destination: MediaDetailView(presenter: MediaDetailPresenter(interactor: MediaDetailInteractor(),
                                                                                    movieId: item.itemID,
                                                                                    mediaType: item.mediaType))) {
            VStack {
                AsyncImage(
                    url: URL(string: self.item.imgUrl),
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        CommonMocks.posterPlaceholder
                    }
                )
                .scaledToFit()
                .frame(width: 140, height: 210)
            }
            .border(Color.primary, width: 1)
        }
    }
}

struct DiscoverSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach((1..<10)) { _ in
                    DiscoverSliceItem(item: MovieMocks.discoverSectionItemListItemStub)
                        .frame(width: 140, height: 210, alignment: .center)
                }
            }
        })
    }
}
