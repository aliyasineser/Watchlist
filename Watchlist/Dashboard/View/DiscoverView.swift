//
//  DiscoverView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI
import TMDBSwift

struct DiscoverView: View {
    
    
    private var interactor: DiscoverInteractor
    @ObservedObject var presenter: DiscoverPresenter
    
    init() {
        self.interactor = DiscoverInteractor()
        self.presenter = DiscoverPresenter(self.interactor)
        
        presenter.loadPopularMovies()
        presenter.loadUpcomingMovies()
        presenter.loadMostRecentMovies()
        presenter.loadAiringToday()
        presenter.loadOnTheAir()
        presenter.loadTopRated()
    }
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false){
            DiscoverSlice(sliceTitle: "Most Popular", sliceItems: self.presenter.popularMovies, section: MediaSection.popularMovies)
            DiscoverSlice(sliceTitle: "Most Recent", sliceItems: self.presenter.mostRecentMovies, section: MediaSection.mostRecentMovies)
            DiscoverSlice(sliceTitle: "Coming Soon", sliceItems: self.presenter.upcomingMovies, section: MediaSection.comingSoonMovies)
            DiscoverSlice(sliceTitle: "Airing Today", sliceItems: self.presenter.airingTodaySeries, section: MediaSection.airingTodaySeries)
            DiscoverSlice(sliceTitle: "On The Air", sliceItems: self.presenter.onTheAirSeries, section: MediaSection.onTheAirSeries)
            DiscoverSlice(sliceTitle: "Top Rated", sliceItems: self.presenter.topRatedSeries, section: MediaSection.topRatedSeries)
        }
        .navigationBarTitle("Discover", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        .background(Color.veryLightPink)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
