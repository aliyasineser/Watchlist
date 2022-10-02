//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI

@MainActor
struct DiscoverSliceItem: View {

    var item: Watchable
    @State var isAppeared = false

    init(item: Watchable) {
        self.item = item
    }

    fileprivate func posterImage() -> some View {
        return VStack {
            if isAppeared {
                AsyncImage(
                    url: URL(string: self.item.posterUrl()),
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
    func getMediaDetailView(mediaType: Watchable.Type) -> some View {
        VStack {
            if mediaType == Movie.self {
                MovieDetailView(
                    presenter: MovieDetailDefaultPresenter(
                        interactor: DefaultMovieDetailInteractor(),
                        id: item.id
                    )
                )
            } else {
                TVSerieDetailView(
                    presenter: TVSerieDetailDefaultPresenter(
                        interactor: DefaultTVSerieDetailInteractor(),
                        id: item.id
                    )
                )
            }
        }
    }
    var body: some View {
        NavigationLink(
            destination: getMediaDetailView(mediaType: type(of: item))
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
                        item: Movie.mock
                    )
                    .frame(width: 140, height: 210, alignment: .center)
                }
            }
        })
    }
}
