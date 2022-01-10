//
//  CastItemView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.09.2021.
//

import SwiftUI
import SDWebImageSwiftUI

struct CastItemView: View {
    
    private var castEntity: CastEntity
    
    internal init(castEntity: CastEntity) {
        self.castEntity = castEntity
    }
    
    var body: some View {
        VStack(alignment: .center) {
            WebImage(url: URL(string: self.castEntity.imageUrl))
                .placeholder(
                    Image(systemName: "person.fill")
                        .resizable()
                )
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 120)
                .clipped()
            
            Text(self.castEntity.name)
                .font(.custom("AppleGothic", size: 15))
                .fontWeight(.regular)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.7)
                .padding(EdgeInsets(top: 0, leading: 2, bottom: 4, trailing: 2))
            
            Text(self.castEntity.character)
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
            CastItemView(castEntity: CastMocks.castEntity)
        }
        .padding()
    }
}
