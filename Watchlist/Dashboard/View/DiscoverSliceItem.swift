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
    
        NavigationLink(destination: MediaDetailView(item.id, mediaType: item.mediaType)) {
            VStack{
                WebImage(url: URL(string: self.item.imgUrl))
                    .placeholder(
                        Placeholder.posterPlaceholder
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
                    DiscoverSliceItem(item: DiscoverSectionItemEntity(id: id, title: "Very Very  Movie Title ", year: "31 - 07 - 2021", imgUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", genre: "Comedy", mediaType: .movie))
                        .frame(width: 136, height: 227, alignment: .center)
                }
            }
        })
        
    }
}
