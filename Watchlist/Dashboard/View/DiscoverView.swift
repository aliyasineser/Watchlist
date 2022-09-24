//
//  DiscoverView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI
import Combine

struct DiscoverView: View {
    @ObservedObject var presenter: DiscoverPresenter

    init(presenter: DiscoverPresenter) {
        self.presenter = presenter
        presenter.fetchMedia()
    }

    var body: some View {

        NavigationView {
            ScrollView(.vertical, showsIndicators: true ) {
                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.mostPopular,
                    sliceItems: self.presenter.popularMovies,
                    section: MediaSection.popularMovies,
                    type: .movie
                )

                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.mostRecent,
                    sliceItems: self.presenter.mostRecentMovies,
                    section: MediaSection.mostRecentMovies,
                    type: .movie
                )

                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.comingSoon,
                    sliceItems: self.presenter.upcomingMovies,
                    section: MediaSection.comingSoonMovies,
                    type: .movie
                )

                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.airingToday,
                    sliceItems: self.presenter.airingTodaySeries,
                    section: MediaSection.airingTodaySeries,
                    type: .tv
                )

                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.onTheAir,
                    sliceItems: self.presenter.onTheAirSeries,
                    section: MediaSection.onTheAirSeries,
                    type: .tv
                )

                DiscoverSlice(
                    sliceTitle: ConstantTexts.SectionHeader.topRated,
                    sliceItems: self.presenter.topRatedSeries,
                    section: MediaSection.topRatedSeries,
                    type: .tv
                )
            }
            .navigationBarTitle(ConstantTexts.NavigationBarTitle.discoverScreen)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(
                EdgeInsets(
                    top: 5,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
            )
        }
    }

}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = MediaInteractorStub()
        let presenter = DiscoverPresenter(interactor)
        DiscoverView(presenter: presenter)
    }
}
