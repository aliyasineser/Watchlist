//
//  ReviewItem.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 2.10.2022.
//

import SwiftUI

struct ReviewItem: View {

    let review: Review
    @State var isExpanded: Bool = false

    var body: some View {
        VStack {
            HStack {
                if let avatarUrl = review.authorDetails.getAvatarUrl() {
                    AsyncImage(
                        url: avatarUrl,
                        content: { image in
                            image.resizable()
                                .scaledToFit()
                                .clipped()
                        },
                        placeholder: {
                            Image(systemName: Icons.artistImageBackdrop.rawValue)
                                .scaledToFit()
                                .clipped()
                        }
                    )
                    .frame(width: 50, height: 50)
                }

                Text(review.author)
                    .bold()
                    .foregroundColor(.accentColor)
                Spacer()

                if let createdAt = review.createdAt {
                    Text(
                        createdAt.formatted(
                            date: .abbreviated,
                            time: .omitted
                        )
                    )
                }
            }
            .padding(.bottom)

            Text(review.content)
                .lineLimit(isExpanded ? nil : 3)
                .multilineTextAlignment(.leading)

            if review.content.count > 100 {
                HStack {
                    Spacer()
                    Button {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    } label: {
                        Text(isExpanded ? "less" : "more")
                    }
                }
            }
        }
        .padding()
        .border(
            width: 1,
            edges: Edge.allCases,
            color: .accentColor
        )
        .cornerRadius(10)
    }
}

struct ReviewItem_Previews: PreviewProvider {
    static var previews: some View {
        ReviewItem(review: .mock)
    }
}
