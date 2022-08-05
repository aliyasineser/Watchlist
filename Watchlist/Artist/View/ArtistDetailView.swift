//
//  ArtistDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI


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
                        
                        AsyncImage(
                            url: URL(string: artist.imgUrl),
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(height: 400, alignment: .center)
                                    .clipped()
                            },
                            placeholder: {
                                CommonMocks.posterPlaceholder
                                    .resizable()
                                    .frame(height: 400, alignment: .center)
                                    .clipped()
                            }
                        )
                        
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
                                .font(.system(size: 30))
                                .bold()
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            if let birthday = artist.birthday {
                                Text(birthday)
                                    .font(.system(size: 16))
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
                if presenter.artistImages.count > 1 {
                    ZStack {
                        AsyncImage(
                            url: URL(string: self.presenter.artistDetail?.imgUrl ?? ""),
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 100)
                            },
                            placeholder: {
                                CommonMocks.posterPlaceholder
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 100)
                            }
                        )
                        Rectangle()
                            .foregroundColor(.teal).opacity(0.7)
                        
                        VStack {
                            Text("\(presenter.artistImages.count)\(presenter.artistImages.count > 1 ? "+" : "")")
                                .font(.system(size: 25))
                                .bold()
                                .minimumScaleFactor(0.7)
                                .lineLimit(1)
                            
                            Text(ConstantTexts.artistDetailScreenPhotoAlbumsButtonText)
                                .font(.system(size: 14))
                                .bold()
                                .minimumScaleFactor(0.5)
                        }
                        .onTapGesture {
                            // Navigation to artist images
                        }
                    }
                }
                
                LazyHStack{
                    ForEach(self.presenter.artistImages.reversed()) { imageEntity in
                        AsyncImage(
                            url: URL(string: imageEntity.getPosterUrl()),
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 100)
                            },
                            placeholder: {
                                CommonMocks.posterPlaceholder
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                                    .frame(width: 100)
                            }
                        )
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
