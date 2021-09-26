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
    var section: MediaSection
    var type: MediaType
    @Environment(\.colorScheme) var colorScheme

    
    internal init(sliceTitle: String, sliceItems: [DiscoverSectionItemEntity], section: MediaSection, type: MediaType) {
        self.sliceTitle = sliceTitle
        self.sliceItems = sliceItems
        self.section = section
        self.type = type
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(self.sliceTitle)
                    .font(.custom("AppleGothic", size: 20) )
                    .bold()
                Spacer()
                NavigationLink(destination: MovieListView(section: self.section)) {
                    HStack(alignment: .center, spacing: 1.0) {
                        Text("See All")
                            .foregroundColor(.blue)
                            .font(.custom("AppleGothic", size: 20) )
                            .bold()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.blue)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
                    }.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }
            
                
                
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 5))
            
            ScrollView (.horizontal, showsIndicators: false){
                HStack(alignment: .center, spacing: 10, content: {
                    ForEach(self.sliceItems, id: \.id) { item in
                            DiscoverSliceItem(item: item)
                                .frame(width: 136, height: 227, alignment: .center)
                    }
                }).padding()
            }
            
        }
        
        
        
    }
    
}

struct DiscoverSlice_Previews: PreviewProvider {
    
    static let movie: MovieMDB = MovieMDB(results: "")
    
    static var previews: some View {
        DiscoverSlice(sliceTitle: "Title", sliceItems: [DiscoverSectionItemEntity(id: 1, title: "Very Very Long Movie Title", year: "21 - 05 - 2021", imgUrl: "", genre: "Comedy", mediaType: .movie)], section: MediaSection.popularMovies, type: .movie)
    }
}
