//
//  MovieDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 5.07.2021.
//

import SwiftUI
import SDWebImageSwiftUI
import TMDBSwift

struct MediaDetailView: View {
    
    @ObservedObject var presenter: MediaDetailPresenter
    
    init(presenter: MediaDetailPresenter) {
        self.presenter = presenter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { gp in
                ScrollView {
                    VStack {
                        ZStack(alignment: .bottom) {
                            WebImage(url: URL(string: presenter.media.image_path))
                                .placeholder(
                                    CommonMocks.posterPlaceholder
                                        .resizable()
                                )
                                .resizable()
                                .scaledToFill()
                                .frame(height: 300)
                                .clipped()

                            Rectangle()
                                .fill(
                                    LinearGradient(gradient: Gradient(stops: [
                                        .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                                        .init(color: Color(UIColor.systemBackground), location: 1)
                                    ]), startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: 0.3 * gp.size.width)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(width: gp.size.width, height: 300, alignment: .center)
                
                        HStack(alignment: .top) {
                            WebImage(url: URL(string: presenter.media.image_path))
                                .placeholder(
                                    CommonMocks.posterPlaceholder
                                        .resizable()
                                )
                                .resizable()
                                .scaledToFill()
                                .frame(width: 160, height: 220, alignment: .center)
                                .clipped()
                            
                            VStack(alignment: .leading) {
                                Text(presenter.media.title)
                                    .font(.custom("AppleGothic", size: 25) )
                                    .bold()
                                    .minimumScaleFactor(0.65)
                                    .lineLimit(2)
                                    .padding(.bottom, 2)
                                
                                Text(presenter.media.genres)
                                    .font(.custom("AppleGothic", size: 17) )
                                    .foregroundColor(.primary)
                                    .bold()
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)
                                
                                HStack {
                                    StarsView(rating: CGFloat(presenter.media.point/2.0), maxRating: 5)
                                        .frame(width: 110, alignment: .center)
                                    Text(String(format: "%.1f / 10", presenter.media.point))
                                        .font(.custom("AppleGothic", size: 14) )
                                        .bold()
                                        .foregroundColor(.primary)
                                        .minimumScaleFactor(0.7)
                                        .clipped()
                                }
                                
                                // TODO: Movie Language, add later
//                                Text(presenter.media.language)
//                                    .font(.custom("AppleGothic", size: 18) )
//                                    .bold()
//                                    .foregroundColor(.primary)
//                                    .minimumScaleFactor(0.8)
                                
                                Text(presenter.media.date + " " + presenter.media.time)
                                    .font(.custom("AppleGothic", size: 17) )
                                    .bold()
                                    .foregroundColor(.primary)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                                    .padding(.top, 3)
                            }
                            .padding(.leading, 5)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .frame(width: gp.size.width, height: 200, alignment: .top)
                        
                        ScrollView {
                            Text(presenter.media.summary)
                                .font(.custom("AppleGothic", size: 16))
                                
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 25)
                        
//                        ExpandableText(presenter.media.summary,
//                           lineLimit: 10,
//                           font: UIFont(name: "AppleGothic", size: 16) ?? UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
//                           )
//                        .padding(.horizontal, 10)
//                        .padding(.top, 25)
                        
                        MediaDetailTabView(self.presenter.mediaId, mediaType: self.presenter.mediaType)
                            .padding(.top, 20)
                        
                    }
                    
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle(self.presenter.media.title)
        .onAppear {
            presenter.getMediaDetail()
        }
        
    }
    
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaDetailView(presenter: MediaDetailPresenter(interactor: MediaDetailInteractor(), movieId: 1285, mediaType: .movie))
                .preferredColorScheme(.dark)
                .navigationBarTitleDisplayMode(.inline)
        }
            
    }
}
