//
//  MediaDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 5.07.2021.
//

import SwiftUI

struct MediaDetailView: View {

    @ObservedObject var presenter: MediaDetailPresenter

    init(presenter: MediaDetailPresenter) {
        self.presenter = presenter
        presenter.getMediaDetail()
    }

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        ZStack(alignment: .bottom) {
                            AsyncImage(
                                url: URL(string: presenter.media.imagePath),
                                content: { image in
                                    image.resizable()
                                },
                                placeholder: {
                                    Image(systemName: "film")
                                }
                            )
                            .scaledToFill()
                            .frame(height: 300)
                            .clipped()

                            Rectangle()
                                .fill(
                                    LinearGradient(gradient: Gradient(stops: [
                                        .init(color: Color(UIColor.systemBackground).opacity(0.01), location: 0),
                                        .init(color: Color(UIColor.systemBackground), location: 1)
                                    ]), startPoint: .top, endPoint: .bottom)
                                )
                                .frame(height: 0.3 * geometry.size.width)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .frame(width: geometry.size.width, height: 300, alignment: .center)

                        HStack(alignment: .top) {
                            AsyncImage(
                                url: URL(string: presenter.media.imagePath),
                                content: { image in
                                    image.resizable()
                                        .scaledToFill()
                                        .clipped()
                                },
                                placeholder: {
                                    Image(systemName: "film")
                                        .scaledToFill()
                                        .clipped()
                                }
                            )

                            VStack(alignment: .leading) {
                                Text(presenter.media.title)
                                    .font(.system(size: 25))
                                    .bold()
                                    .minimumScaleFactor(0.65)
                                    .lineLimit(2)
                                    .padding(.bottom, 2)

                                Text(presenter.media.genres)
                                    .font(.system(size: 17))
                                    .foregroundColor(.primary)
                                    .bold()
                                    .minimumScaleFactor(0.7)
                                    .lineLimit(1)

                                HStack {
                                    StarsView(rating: CGFloat(presenter.media.point/2.0), maxRating: 5)
                                        .frame(width: 110, alignment: .center)
                                    Text(String(format: "%.1f / 10", presenter.media.point))
                                        .font(.system(size: 14))
                                        .bold()
                                        .foregroundColor(.primary)
                                        .minimumScaleFactor(0.7)
                                        .clipped()
                                }

                                if let lang = OriginalLanguage(isoCode: presenter.media.language)?.language {
                                    Text(lang)
                                        .font(.system(size: 18))
                                        .bold()
                                        .foregroundColor(.primary)
                                        .minimumScaleFactor(0.8)
                                }

                                Text(presenter.media.date + " " + presenter.media.time)
                                    .font(.system(size: 17))
                                    .bold()
                                    .foregroundColor(.primary)
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                                    .padding(.top, 3)
                            }
                            .padding(.leading, 5)
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .frame(width: geometry.size.width, alignment: .top)
                        ScrollView {
                            Text(presenter.media.summary)
                                .font(.system(size: 16))
                        }
                        .padding(.horizontal, 10)
                        .padding(.top, 25)

                        MediaDetailTabView(self.presenter.mediaId, mediaType: self.presenter.mediaType)
                            .padding(.top, 20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationTitle(self.presenter.media.title)
        .onAppear {
            presenter.getMediaDetail()
        }
    }
}

struct MediaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MediaDetailView(presenter: MediaDetailPresenter(interactor: MediaDetailInteractor(),
                                                            movieId: 1285, mediaType: .movie))
                .preferredColorScheme(.dark)
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
