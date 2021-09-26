//
//  ArtistItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct ArtistItemView: View {
    
    internal init(id: Int, imageUrl: String, name: String) {
        self.id = id
        self.imageUrl = imageUrl
        self.name = name
    }
    
    var id: Int
    var imageUrl: String
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: self.imageUrl))
                .placeholder(
                    Image(systemName: "person.fill")
                        .resizable()
                )
                .resizable()
                .scaledToFill()
                .frame(width: 105, height: 160)
                .clipped()
            
            Text(self.name)
                .font(.custom("AppleGothic", size: 15))
                .foregroundColor(.primary)
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(EdgeInsets(top: 4, leading: 2, bottom: 4, trailing: 2))
                
        }
        .frame(width: 105, height: 190)
        .border(Color.primary, width: 1)
    }
}

struct ArtistItemView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ArtistItemView(id: 1, imageUrl: "https://m.media-amazon.com/images/M/MV5BN2EyZjM3NzUtNWUzMi00MTgxLWI0NTctMzY4M2VlOTdjZWRiXkEyXkFqcGdeQXVyNDUzOTQ5MjY@._V1_UX182_CR0,0,182,268_AL_.jpg", name: "Artist_Name Artist_Surname")
        }
        .padding()
    }
}
