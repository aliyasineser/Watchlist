//
//  CastItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CastItemView: View {
    
    internal init(imageUrl: String, name: String, character: String) {
        self.imageUrl = imageUrl
        self.name = name
        self.character = character
    }
    
    var imageUrl: String
    var name: String
    var character: String
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: self.imageUrl))
                .placeholder(
                    Image(systemName: "person.fill")
                        .resizable()
                )
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .clipped()
            
            Text(self.name)
                .font(.custom("AppleGothic", size: 15))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(EdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2))
            
            Text(self.character)
                .font(.custom("AppleGothic", size: 13))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(EdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2))
                
        }
        .frame(width: 100, height: 175)
        .border(Color.primary, width: 1)
    }
}

struct CastItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CastItemView(imageUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", name: "Artist_Name Artist_Surname", character: "Character")
        }
        .padding()
    }
}
