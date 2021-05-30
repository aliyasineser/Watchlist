//
//  DiscoverView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 13.05.2021.
//

import SwiftUI
import TMDBSwift

struct DiscoverView: View {
    
    @ObservedObject var imageLoader: ImageLoader
//    @State var image:UIImage = UIImage()
    
    private var interactor: DiscoverInteractor
    @ObservedObject var presenter: DiscoverPresenter
    
    init() {
        self.interactor = DiscoverInteractor()
        self.presenter = DiscoverPresenter(self.interactor)
        self.imageLoader = ImageLoader()
        
        presenter.loadPopularMovies()
    }
    
    var body: some View {
        List(self.presenter.popularMovies, id: \.id) { item in
            if let title = item.title, let year = item.release_date, let imgUrl = item.backdrop_path {
                DiscoverSectionItem(item: DiscoverSectionItemEntity(title: title, year: year, imgUrl: imgUrl ))
            }
        }
    }
}

struct DiscoverView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverView()
    }
}
