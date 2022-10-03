//
//  ArtistDetailTabView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI

struct ArtistDetailTabView: View {

    @State var tabIndex = 0

    var artistDetail: ArtistDetail
    var artistMovieCredits: [Cast]
    var artistTVSerieCredits: [Cast]

    init(
        artistDetail: ArtistDetail,
        artistMovieCredits: [Cast],
        artistTVSerieCredits: [Cast]
    ) {
        self.artistDetail = artistDetail
        self.artistMovieCredits = artistMovieCredits
        self.artistTVSerieCredits = artistTVSerieCredits
    }

    func mediaCard(credit: Cast) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            Text(credit.getTitle())
                .font(.title2)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
            Text(credit.getRole())
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }

    fileprivate func creditMediaPoster(showCredit: Cast) -> some View {
        AsyncImage(
            url: URL(string: showCredit.getPosterUrl()),
            content: { image in
                image.resizable()
                    .scaledToFit()
            },
            placeholder: {
                Image(systemName: "film")
            }
        )
        .frame(
            width: 130,
            height: 200,
            alignment: .center
        )
        .border(
            width: 1,
            edges: Edge.allCases,
            color: .accentColor
        )
        .clipped()
    }

    var body: some View {
        VStack {
            ArtistDetailTopTabBar(tabIndex: $tabIndex)
            ScrollView(.vertical) {
                if tabIndex == 0 {
                    ScrollView {
                        Text(self.artistDetail.biography!)
                    }
                } else if tabIndex == 1 {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                                ForEach(artistMovieCredits, id: \.creditID) { showCredit in
                                    NavigationLink(
                                        destination: MovieDetailView(
                                            presenter: MovieDetailDefaultPresenter(
                                                interactor: DefaultMovieDetailInteractor(),
                                                id: showCredit.id
                                            )
                                        )
                                    ) {
                                        HStack {
                                            creditMediaPoster(showCredit: showCredit)
                                            mediaCard(credit: showCredit)
                                        }
                                    }
                                }

                                ForEach(artistTVSerieCredits, id: \.creditID) { showCredit in
                                    NavigationLink(
                                        destination: TVSerieDetailView(
                                            presenter: TVSerieDetailDefaultPresenter(
                                                interactor: DefaultTVSerieDetailInteractor(),
                                                id: showCredit.id
                                            )
                                        )
                                    ) {
                                        HStack {
                                            creditMediaPoster(showCredit: showCredit)
                                            mediaCard(credit: showCredit)
                                        }
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(
            width: UIScreen.main.bounds.width - 24,
            alignment: .center
        )
        .padding(.horizontal, 12)
    }
}

struct ArtistDetailTopTabBar: View {

    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(
                text: "Summary",
                isSelected: .constant(tabIndex == 0)
            )
            .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton(
                text: "Movies",
                isSelected: .constant(tabIndex == 1)
            )
            .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
        }
        .border(
            width: 2,
            edges: [.bottom],
            color: Color.accentColor
        )
    }

    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct ArtistDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailTabView(
            artistDetail: ArtistDetail.mock,
            artistMovieCredits: [],
            artistTVSerieCredits: []
        )
    }
}
