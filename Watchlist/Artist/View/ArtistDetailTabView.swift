//
//  ArtistDetailTabView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI

struct ArtistDetailTabView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    var artistDetail: ArtistDetailEntity
    
    
    init(_ artistDetail: ArtistDetailEntity) {
        self.artistDetail = artistDetail
    }
    
    var body: some View {
        VStack{
            ArtistDetailTopTabBar(tabIndex: $tabIndex)
            if tabIndex == 0 {
                ScrollView {
                    Text(self.artistDetail.biography!)
                }
            }
            else if tabIndex == 1 {
                Text("Movies")
            }
            else {
                Text("More")
            }
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width - 24, alignment: .center)
        .padding(.horizontal, 12)
        .background(colorScheme != .dark ? Color.white : Color.black)
    }
}

struct ArtistDetailTopTabBar: View {
    @Environment(\.colorScheme) var colorScheme

    
    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(text: "Summary", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
                Spacer()
            TabBarButton(text: "Movies", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
            TabBarButton(text: "More", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
            Spacer()
        }
        .border(width: 2, edges: [.bottom], color: Color.secondary)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}


struct ArtistDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailTabView(ArtistDetailEntity())
    }
}
