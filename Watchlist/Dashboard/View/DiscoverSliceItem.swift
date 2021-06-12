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
        
        VStack{
            WebImage(url: URL(string: self.item.imgUrl))
                .placeholder(
                    Image("onboarding1")
                        .resizable()
                )
                .resizable()
                .frame(width: 136, height: 181)
                .scaledToFit()
                
        
            Text(self.item.title)
                .font(.custom("AppleGothic", size: 19) )
                .bold()
                .allowsTightening(true)
                .minimumScaleFactor(0.7)
            
            Text(self.item.year)
                .font(.custom("AppleGothic", size: 14))
        }
        .background(Color.white)
        .scaledToFit()
        
    }
}

struct DiscoverSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack {
                ForEach((1..<10)) {id in
                    DiscoverSliceItem(item: DiscoverSectionItemEntity(id: id, title: "Preview Movie Title ", year: "31 - 07 - 2021", imgUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg"))
                }
            }
        })
        .background(Color.gray)
    }
}
