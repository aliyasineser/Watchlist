//
//  DiscoverSlice.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 1.06.2021.
//

import SwiftUI
import TMDBSwift

struct DiscoverSlice: View {
    
    var sliceTitle: String
    var sliceItems: [DiscoverSectionItemEntity]
    
    internal init(sliceTitle: String, sliceItems: [DiscoverSectionItemEntity]) {
        self.sliceTitle = sliceTitle
        self.sliceItems = sliceItems
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(self.sliceTitle)
                    .font(.custom("AppleGothic", size: 20) )
                    .bold()
                Spacer()
                HStack(alignment: .center, spacing: 1.0) {
                    Text("See All")
                        .foregroundColor(.blue)
                        .font(.custom("AppleGothic", size: 20) )
                        .bold()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.blue)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                
            }
            .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
            
            
            
            ScrollView (.horizontal, showsIndicators: false){
                HStack(alignment: .center, spacing: 10, content: {
                    ForEach(self.sliceItems, id: \.id) { item in
                            DiscoverSliceItem(item: item)
                                .frame(width: 136, height: 227, alignment: .center)
                    }
                }).padding()
            }
            
        }.background(Color.veryLightPink)
    }
    
}

struct DiscoverSlice_Previews: PreviewProvider {
    
    static let movie: MovieMDB = MovieMDB(results: "")
    
    static var previews: some View {
        DiscoverSlice(sliceTitle: "Title", sliceItems: [DiscoverSectionItemEntity(id: 1, title: "Movie Title", year: "21 - 05 - 2021", imgUrl: "")])
    }
}
