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
    }
    
    var body: some View {
        ScrollView(.vertical) {
            if let artist = self.presenter.artistDetail {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        WebImage(url: URL(string: artist.imgUrl))
                            .placeholder(
                                CommonMocks.posterPlaceholder
                                    .resizable()
                            )
                            .resizable()
                            .scaledToFill()
                            .frame(height: 400, alignment: .center)
                            .clipped()
                    
                        Rectangle()
                            .fill(
                                LinearGradient(gradient: Gradient(stops: [
                                    .init(color: Color(UIColor.gray).opacity(0.01), location: 0),
                                    .init(color: Color(UIColor.gray).opacity(0.8), location: 1)
                                ]), startPoint: .top, endPoint: .bottom)
                            )
                            .frame(height: 200)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        VStack(alignment: .leading) {
                            Text(artist.name)
                                .font(.custom("AppleGothic", size: 30) )
                                .bold()
                                .minimumScaleFactor(0.7)
                            .lineLimit(1)
                            
                            if let birthday = artist.birthday {
                                Text(birthday)
                                    .font(.custom("AppleGothic", size: 16) )
                                    .bold()
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                            }
                            
                        }
                        .padding()
                    }
                    
                    PhotoGrid(presenter: self.presenter)
                        .frame(height: 150)
                    
                    ArtistDetailTabView(artist, artistCredits: self.presenter.artistCredits)
                        .padding(10)
                        .ignoresSafeArea()
                }
                .clipped()
            }
        }
        .onAppear(perform: {
            self.presenter.fetchArtist(artistId: artistId)
        })
        .ignoresSafeArea()
    }
}


struct PhotoGrid: View {
    
    @ObservedObject var presenter: ArtistDetailPresenter
    
    init(presenter: ArtistDetailPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        
            ScrollView(.horizontal){
                HStack(spacing: 0) {
                    ZStack {
                        WebImage(url: URL(string: self.presenter.artistDetail?.imgUrl ?? ""))
                            .placeholder(
                                CommonMocks.posterPlaceholder
                                    .resizable()
                            )
                            .resizable()
                            .scaledToFill()
                            .clipped()
                        
                        Rectangle()
                            .foregroundColor(.teal).opacity(0.7)
                        
                        VStack {
                            Text("\(presenter.artistImages.count)\(presenter.artistImages.count > 1 ? "+" : "")")
                                .font(.custom("AppleGothic", size: 25) )
                                .bold()
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            Text(ConstantTexts.artistDetailScreenPhotoAlbumsButtonText)
                                .font(.custom("AppleGothic", size: 14) )
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onTapGesture {
                            // Navigation to artist images
                        }
                        
                    }
                    
                HStack{
                    ForEach(self.presenter.artistImages.reversed()) { imageEntity in
                        WebImage(url: URL(string: imageEntity.getPosterUrl()))
                        .placeholder(
                            CommonMocks.posterPlaceholder
                                .resizable()
                        )
                        .resizable()
                        .scaledToFill()
//                        .frame(width: 120, height: 120, alignment: .center)
                        .clipped()
                    }
                }
            }
            Spacer()
        }
            .padding(.leading)
        
    }
}


struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistDetailView(artistId: 21)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
