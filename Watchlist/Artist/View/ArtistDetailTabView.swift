//
//  ArtistDetailTabView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistDetailTabView: View {

    @State var tabIndex = 0
    
    var artistDetail: ArtistDetailEntity
    var artistCredits: [MediaCreditEntity]
    
    
    init(_ artistDetail: ArtistDetailEntity, artistCredits: [MediaCreditEntity]) {
        self.artistDetail = artistDetail
        self.artistCredits = artistCredits
    }
    
    var body: some View {
        
            VStack{
                ArtistDetailTopTabBar(tabIndex: $tabIndex)
                ScrollView(.vertical) {
                    if tabIndex == 0 {
                        ScrollView {
                            Text(self.artistDetail.biography!)
                        }
                    }
                    else if tabIndex == 1 {
                        ScrollView(.vertical) {
                            VStack(alignment: .leading) {
                                ForEach(self.artistCredits) { showCredit in
                                    HStack(spacing: 10) {
                                        WebImage(url: URL(string: TMDBUrl.imageBaseUrl + showCredit.image_path))
                                            .placeholder(
                                                Placeholder.posterPlaceholder
                                                    .resizable()
                                            )
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 150, height: 270, alignment: .center)
                                            .clipped()
                                        
                                        VStack {
                                            Text(showCredit.title)
                                                .font(.custom("AppleGothic", size: 18) )
                                                .bold()
                                                .minimumScaleFactor(0.7)
                                                .lineLimit(1)
                                            
                                            Text(showCredit.role)
                                                .font(.custom("AppleGothic", size: 13) )
                                                .bold()
                                                .minimumScaleFactor(0.7)
                                                .lineLimit(1)
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
            .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
            .padding(.horizontal, 12)
        
    }
}

struct ArtistDetailTopTabBar: View {

    
    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(text: "Summary", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton(text: "Movies", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
        }
        .border(width: 2, edges: [.bottom], color: Color.secondary)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}


struct ArtistDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailTabView(ArtistDetailEntity(), artistCredits: [])
    }
}
