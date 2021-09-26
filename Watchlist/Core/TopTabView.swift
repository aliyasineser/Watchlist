//
//  TopTabBar.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 8.08.2021.
//

import SwiftUI



struct TopTabView: View {
    
    @State private var selectedIndex: Int = 0
    let views : [String :AnyView]
    
    
    init(_ views: [String: AnyView]) {
        self.views = views
    }
    
    func getBar() -> HStack<Text> {
        return HStack(alignment: .top, spacing: 3) {
            views.enumerated().forEach { item in
                Text(item.element.key)
                    .fontWeight(selectedIndex == item.offset ? .heavy : .regular)
                    .font(.custom("Avenir", size: 16))
                    .padding(.bottom,10)
            }
        }
    }
    
    var body: some View {
        
        
         
    }
}

struct TopTabBar_Previews: PreviewProvider {
    static var previews: some View {
        TopTabView(
            [
                "First": AnyView(Text("First")),
                "Second": AnyView(Text("Second")),
                "Third": AnyView(Text("Third"))
            ]
        )
    }
}
