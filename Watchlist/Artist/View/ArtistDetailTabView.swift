//
//  ArtistDetailTabView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import CachedAsyncImage

struct ArtistDetailTabView: View {

    @State var tabIndex = 0

    var artistDetail: ArtistDetailEntity
    var artistCredits: [MediaCreditEntity]

    init(_ artistDetail: ArtistDetailEntity, artistCredits: [MediaCreditEntity]) {
        self.artistDetail = artistDetail
        self.artistCredits = artistCredits
    }

    func mediaCard(credit: MediaCreditEntity) -> some View {
        return VStack(alignment: .leading, spacing: 10) {
            Text(credit.title)
                .font(.title2)
                .lineLimit(3)
                .minimumScaleFactor(0.8)
                .multilineTextAlignment(.leading)
            Text(credit.role)
                .font(.subheadline)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }

    fileprivate func creditMediaPoster(showCredit: MediaCreditEntity) -> some View {
        return CachedAsyncImage(
            url: URL(string: showCredit.imagePath),
            content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(
                        width: 130,
                        height: 200,
                        alignment: .center
                    )
                    .border(
                        width: 1,
                        edges: Edge.allCases,
                        color: .black
                    )
                    .clipped()
            },
            placeholder: {
                Image(systemName: "film")
                    .frame(
                        width: 130,
                        height: 200,
                        alignment: .center
                    )
                    .border(
                        width: 1,
                        edges: Edge.allCases,
                        color: .black
                    )
                    .clipped()
            }
        )
    }

    var body: some View {
        VStack {
            ArtistDetailTopTabBar(tabIndex: $tabIndex)
            ScrollView(.vertical) {
                if tabIndex == 0 {
                    ScrollView {
                        Text(self.artistDetail.biography!)
                    }
                } else if tabIndex == 1 {
                    ScrollView(.vertical) {
                        VStack(alignment: .leading) {
                            ForEach(self.artistCredits) { showCredit in
                                HStack {
                                    creditMediaPoster(showCredit: showCredit)
                                    mediaCard(credit: showCredit)
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
        }
        .frame(
            width: UIScreen.main.bounds.width - 24,
            alignment: .center
        )
        .padding(.horizontal, 12)
    }
}

struct ArtistDetailTopTabBar: View {

    @Binding var tabIndex: Int
    var body: some View {
        HStack {
            Spacer()
            TabBarButton(
                text: "Summary",
                isSelected: .constant(tabIndex == 0)
            )
            .onTapGesture { onButtonTapped(index: 0) }
            Spacer()
            TabBarButton(
                text: "Movies",
                isSelected: .constant(tabIndex == 1)
            )
            .onTapGesture { onButtonTapped(index: 1) }
            Spacer()
        }
        .border(
            width: 2,
            edges: [.bottom],
            color: Color.secondary
        )
    }

    private func onButtonTapped(index: Int) {
        withAnimation { tabIndex = index }
    }
}

struct ArtistDetailTabView_Previews: PreviewProvider {
    static var previews: some View {
        ArtistDetailTabView(ArtistDetailEntity.mock, artistCredits: [])
    }
}
