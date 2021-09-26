//
//  MovieDetailTabView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 9.08.2021.
//

import SwiftUI

struct MediaDetailTabView: View {
    @Environment(\.colorScheme) var colorScheme

    @State var tabIndex = 0
    
    var id: Int
    var mediaType: MediaType
    
    init(_ id: Int, mediaType: MediaType) {
        self.id = id
        self.mediaType = mediaType
    }
    
    var body: some View {
        VStack{
            CustomTopTabBar(tabIndex: $tabIndex)
            if tabIndex == 0 {
                CastView(self.id, mediaType: self.mediaType)
            }
            else if tabIndex == 1 {
                Text("Reviews")
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

struct CustomTopTabBar: View {
    @Environment(\.colorScheme) var colorScheme

    
    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(text: "Cast", isSelected: .constant(tabIndex == 0))
                .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton(text: "Reviews", isSelected: .constant(tabIndex == 1))
                .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
            TabBarButton(text: "More", isSelected: .constant(tabIndex == 2))
                .onTapGesture { onButtonTapped(index: 2) }
            Spacer()
        }
        .border(width: 1, edges: [.bottom], color: Color.secondary)
    }
    
    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct TabBarButton: View {
    @Environment(\.colorScheme) var colorScheme

    let text: String
    @Binding var isSelected: Bool
    var body: some View {
        Text(text)
            .fontWeight(isSelected ? .heavy : .regular)
            .font(.custom("AppleGothic", size: 16))
            .foregroundColor(colorScheme == .dark ? .white : .black)
            .padding(.bottom,10)
            .border(width: isSelected ? 2 : 1, edges: [.bottom], color: .secondary)
    }
}

struct EdgeBorder: Shape {

    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for edge in edges {
            var x: CGFloat {
                switch edge {
                case .top, .bottom, .leading: return rect.minX
                case .trailing: return rect.maxX - width
                }
            }

            var y: CGFloat {
                switch edge {
                case .top, .leading, .trailing: return rect.minY
                case .bottom: return rect.maxY - width
                }
            }

            var w: CGFloat {
                switch edge {
                case .top, .bottom: return rect.width
                case .leading, .trailing: return self.width
                }
            }

            var h: CGFloat {
                switch edge {
                case .top, .bottom: return self.width
                case .leading, .trailing: return rect.height
                }
            }
            path.addPath(Path(CGRect(x: x, y: y, width: w, height: h)))
        }
        return path
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: SwiftUI.Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}


struct MovieDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        MediaDetailTabView(1234, mediaType: .movie)
    }
}
