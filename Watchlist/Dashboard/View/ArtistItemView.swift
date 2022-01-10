//
//  ArtistItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.06.2021.
//

import SwiftUI
import SDWebImageSwiftUI


struct ArtistItemView: View {
    
    private var artistEntity: ArtistEntity
    
    internal init(artistEntity: ArtistEntity) {
        self.artistEntity = artistEntity
    }
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: self.artistEntity.imageUrl))
                .placeholder(
                    Image(systemName: "person.fill")
                        .resizable()
                )
                .resizable()
                .scaledToFill()
                .frame(width: 105, height: 160)
                .clipped()
            
            Text(self.artistEntity.name)
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
            ArtistItemView(artistEntity: CastMocks.artistEntity)
        }
        .padding()
    }
}
