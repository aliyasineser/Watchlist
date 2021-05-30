//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI
import TMDBSwift
import SDWebImageSwiftUI

struct DiscoverSectionItem: View {
    
    var item: DiscoverSectionItemEntity
    
    init(item: DiscoverSectionItemEntity) {
        self.item = item
    }
    
    var body: some View {
        VStack{
            WebImage(url: URL(string: self.item.imgUrl))
                .placeholder(Image("onboarding1"))
                .resizable()
                .aspectRatio(contentMode: .fill)

            Text(self.item.title)
                .font(.custom("AppleGothic", size: 24)).bold()
            Text(self.item.year)
                .font(.custom("AppleGothic", size: 18))
        }
        .scaledToFit()
        
    }
}

struct DiscoverSectionItem_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverSectionItem(item: DiscoverSectionItemEntity(title: "Title", year: "2000", imgUrl: ""))
    }
}
