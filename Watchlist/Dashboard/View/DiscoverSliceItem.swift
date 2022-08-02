//
//  DiscoverSectionItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 25.05.2021.
//

import SwiftUI

struct DiscoverSliceItem: View {
    
    var item: DiscoverSectionItemEntity
    
    init(item: DiscoverSectionItemEntity) {
        self.item = item
    }
    
    var body: some View {
        
        NavigationLink(destination: MediaDetailView(presenter: MediaDetailPresenter(interactor: MediaDetailInteractor(), movieId: item.id, mediaType: item.mediaType))) {
            VStack{
                AsyncImage(
                    url: URL(string: self.item.imgUrl),
                    content: { image in
                        image.resizable()
                    },
                    placeholder: {
                        CommonMocks.posterPlaceholder
                            .resizable()
                    }
                )
                .scaledToFit()
                .frame(width: 140, height: 181)
                
                Text(self.item.title)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .bold()
                    .lineLimit(2)
                
                
                Text(self.item.year)
                    .font(.system(size: 12))
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
