//
//  DiscoverView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//e

import SwiftUI
import Combine

struct DiscoverView: View {
    
    @ObservedObject var presenter: DiscoverPresenter
    
    init(presenter: DiscoverPresenter) {
        self.presenter = presenter
        
        presenter.loadPopularMovies()
        presenter.loadUpcomingMovies()
        presenter.loadMostRecentMovies()
        presenter.loadAiringToday()
        presenter.loadOnTheAir()
        presenter.loadTopRated()
    }
    
    var body: some View {
    
        NavigationView {
            ScrollView (.vertical, showsIndicators: true ) {
                
                if self.presenter.isPopularMoviesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.mostPopularSectionHeader, sliceItems: self.presenter.popularMovies, section: MediaSection.popularMovies, type: .movie)
                } else { ProgressView() }
                if self.presenter.isMostRecentMoviesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.mostRecentSectionHeader, sliceItems: self.presenter.mostRecentMovies, section: MediaSection.mostRecentMovies, type: .movie)
                } else { ProgressView() }
                if self.presenter.isUpcomingMoviesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.comingSoonSectionHeader, sliceItems: self.presenter.upcomingMovies, section: MediaSection.comingSoonMovies, type: .movie)
                } else { ProgressView() }
                if self.presenter.isAiringTodaySeriesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.airingTodaySectionHeader, sliceItems: self.presenter.airingTodaySeries, section: MediaSection.airingTodaySeries, type: .tv)
                } else { ProgressView() }
                if self.presenter.isOnTheAirSeriesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.onTheAirSectionHeader, sliceItems: self.presenter.onTheAirSeries, section: MediaSection.onTheAirSeries, type: .tv)
                } else { ProgressView() }
                if self.presenter.isTopRatedSeriesLoaded {
                    DiscoverSlice(sliceTitle: ConstantTexts.topRatedSectionHeader, sliceItems: self.presenter.topRatedSeries, section: MediaSection.topRatedSeries, type: .tv)
                } else { ProgressView() }
            
            }
            .navigationBarTitle(ConstantTexts.discoverScreenNavBarTitle)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
        
    }

}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = DiscoverInteractor()
        let presenter = DiscoverPresenter(interactor)
        DiscoverView(presenter: presenter)
    }
}
