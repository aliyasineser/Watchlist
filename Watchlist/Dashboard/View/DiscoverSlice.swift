//
//  DiscoverSlice.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 1.06.2021.
//

import SwiftUI


struct DiscoverSlice: View {
    
    var sliceTitle: String
    var sliceItems: [DiscoverSectionItemEntity]
    var section: MediaSection
    var type: MediaType
    
    internal init(sliceTitle: String, sliceItems: [DiscoverSectionItemEntity], section: MediaSection, type: MediaType) {
        self.sliceTitle = sliceTitle
        self.sliceItems = sliceItems
        self.section = section
        self.type = type
    }
    
    var seeAllView: some View {
        HStack(alignment: .center, spacing: 1.0) {
            Text(ConstantTexts.sliceSeeAllButtonText)
                .foregroundColor(.blue)
                .font(.system(size: 20))
                .bold()
            Image(systemName: "chevron.right")
                .foregroundColor(.blue)
                .padding(.bottom, 4)
        }.padding(.trailing, 10)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center) {
                Text(self.sliceTitle)
                    .font(.system(size: 20))
                    .bold()
                Spacer()
                NavigationLink(destination: MovieListView(section: self.section)) {
                    seeAllView
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 5))
            
            ScrollView (.horizontal, showsIndicators: false){
                HStack(alignment: .center, spacing: 10) {
                    ForEach(self.sliceItems, id: \.id) { item in
                        DiscoverSliceItem(item: item)
                            .frame(width: 140, height: 240, alignment: .center)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct DiscoverSlice_Previews: PreviewProvider {
    
    static var previews: some View {
        DiscoverSlice(sliceTitle: "Title", sliceItems: [DiscoverSectionItemEntity(id: 1,
                                                                                  title: "Very Very Long Movie Title", year: "21 - 05 - 2021",
                                                                                  imgUrl: "", genre: "Comedy", mediaType: .movie)],
                      section: MediaSection.popularMovies, type: .movie)
    }
}
