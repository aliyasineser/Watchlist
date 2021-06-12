//
//  ArtistItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct ArtistItemView: View {
    
    internal init(imageUrl: String, name: String) {
        self.imageUrl = imageUrl
        self.name = name
    }
    
    var imageUrl: String
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: self.imageUrl))
                .placeholder(
                    Image("onboarding1")
                        .resizable()
                )
                .resizable()
                .scaledToFill()
                .frame(width: 105, height: 160)
            
            
            Text(self.name)
                .font(.custom("AppleGothic", size: 15))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                
        }
        .frame(width: 105, height: 190)
        .background(Color.init(.white))
    }
}

struct ArtistItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ArtistItemView(imageUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", name: "Artist_Name Artist_Surname")
        }
        .padding()
        .background(Color.init(.gray))
    }
}
