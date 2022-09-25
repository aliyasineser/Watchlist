//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI
import CachedAsyncImage

@MainActor
struct DiscoverSliceItem: View {

    var item: DiscoverSectionItemEntity
    @State var isAppeared = false

    init(item: DiscoverSectionItemEntity) {
        self.item = item
    }

    fileprivate func posterImage() -> some View {
        return VStack {
            if isAppeared {
                CachedAsyncImage(
                    url: URL(string: self.item.imgUrl),
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        VStack {
                            Image(systemName: "film")
                                .padding(.bottom, 10)
                            ProgressView()
                        }
                    }
                )
            } else {
                Image(systemName: "film")
            }
        }
    }

    @MainActor
    func getMediaDetailView(mediaType: MediaType) -> some View {
        VStack {
            if mediaType == .movie {
                MovieDetailView(
                    presenter: MovieDetailPresenter(
                        interactor: DefaultMovieDetailInteractor(),
                        id: item.itemID
                    )
                )
            } else {
                TVSerieDetailView(
                    presenter: TVSerieDetailPresenter(
                        interactor: DefaultTVSerieDetailInteractor(),
                        id: item.itemID
                    )
                )
            }
        }
    }
    var body: some View {
        NavigationLink(
            destination: getMediaDetailView(mediaType: item.mediaType)
        ) {
            VStack {

                posterImage()
                    .scaledToFit()
                    .frame(
                        width: 140,
                        height: 210
                    )
            }
            .border(
                Color.primary,
                width: 1
            )
            .onAppear {
                isAppeared = true
            }
        }
    }
}

struct DiscoverSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach((1..<10)) { _ in
                    DiscoverSliceItem(
                        item: DiscoverSectionItemEntity.mock
                    )
                    .frame(width: 140, height: 210, alignment: .center)
                }
            }
        })
    }
}
