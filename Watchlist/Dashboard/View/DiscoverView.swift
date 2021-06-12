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
    }
    
    var body: some View {
        ScrollView (.vertical, showsIndicators: false){
            DiscoverSlice(sliceTitle: "Most Popular", sliceItems: self.presenter.popularMovies)
            DiscoverSlice(sliceTitle: "Most Recent", sliceItems: self.presenter.mostRecentMovies)
            DiscoverSlice(sliceTitle: "Coming Soon", sliceItems: self.presenter.upcomingMovies)
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        .background(Color.veryLightPink)
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
