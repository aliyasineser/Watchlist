//
//  ArtistDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistDetailView: View {
    
    var interactor: ArtistDetailInteractor
    @ObservedObject var presenter: ArtistDetailPresenter
    var artistId: Int
    
    init(artistId: Int) {
        self.interactor = ArtistDetailInteractor()
        self.presenter = ArtistDetailPresenter(interactor: interactor)
        self.artistId = artistId
        
        self.presenter.fetchArtist(artistId: artistId)
    }
    
    var body: some View {
        VStack {
            VStack {
                WebImage(url: URL(string: self.presenter.artistDetail.imgUrl))
                    .placeholder(
                        Placeholder.posterPlaceholder
                            .resizable()
                    )
                    .resizable()
                    .scaledToFill()
                    .frame(width: 300, height: 300, alignment: .center)
                    .clipped()
            }
            HStack {
                
            }
            ArtistDetailTabView(self.presenter.artistDetail)
                .padding(10)
        }
        .clipped()
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistDetailView(artistId: 10)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
