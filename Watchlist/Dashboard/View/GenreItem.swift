//
//  GenreItem.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 6.06.2021.
//

import SwiftUI

struct GenreItem: View {
    
    var genre: String
    
    init(genre: String) {
        self.genre = genre
    }
    
    var body: some View {
        GeometryReader{
            geo in
            ZStack {
                CommonMocks.posterPlaceholder
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: 200, alignment: .top)
                    .clipped()
                VStack(alignment: .leading) {
                    Spacer()
                    HStack(alignment: .bottom) {
                        Text(self.genre)
                            .font(.custom("AppleGothic", size: 22))
                            .fontWeight(.bold)
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                        Spacer()
                    }.frame(width: geo.size.width, height: 60, alignment: .center)
                    .background(Color(.sRGB, red: 0.6, green: 0.6, blue: 0.6, opacity: 0.6))
                        
                }
                
            }
            .frame(width: geo.size.width, alignment: .top)
        }.frame(height: 200)
    }
}

struct GenreItem_Previews: PreviewProvider {
    static var previews: some View {
        GenreItem(genre: "TestGenre")
    }
}
