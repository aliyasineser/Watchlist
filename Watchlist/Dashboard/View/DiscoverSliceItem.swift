//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI
import TMDBSwift
import SDWebImageSwiftUI

struct DiscoverSliceItem: View {
    
    var item: DiscoverSectionItemEntity
    
    init(item: DiscoverSectionItemEntity) {
        self.item = item
    }
    
    var body: some View {
    
        NavigationLink(destination: MediaDetailView(presenter: MediaDetailPresenter(interactor: MediaDetailInteractor(), movieId: item.id, mediaType: item.mediaType))) {
            VStack{
                WebImage(url: URL(string: self.item.imgUrl))
                    .placeholder(
                        CommonMocks.posterPlaceholder
                            .resizable()
                    )
                    .resizable()
                    .frame(width: 136, height: 181)
                    .scaledToFit()
                    
    
                Text(self.item.title)
                    .font(.custom("AppleGothic", size: 16) )
                    .foregroundColor(.primary)
                    .bold()
                    .lineLimit(2)
                    
                
                Text(self.item.year)
                    .font(.custom("AppleGothic", size: 12))
                    .foregroundColor(.primary)
            }
            .border(Color.primary, width: 1)
            
        }
    
        
    }
}

struct DiscoverSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach((1..<10)) {id in
                    DiscoverSliceItem(item: MovieMocks.discoverSectionItemListItem)
                        .frame(width: 136, height: 227, alignment: .center)
                }
            }
        })
        
    }
}
