//
//  ArtistDetailView.swift
//  Watchlist
//
//  Created by ali.yasin.eser on 11.09.2021.
//

import SwiftUI
import CachedAsyncImage

struct ArtistDetailView: View {

    @ObservedObject var presenter: ArtistDetailPresenter
    var artistId: Int

    init(artistId: Int, presenter: ArtistDetailPresenter) {
        self.presenter = presenter
        self.artistId = artistId
    }

    var body: some View {
        ScrollView(.vertical) {
            if let artist = self.presenter.artistDetail {
                VStack(spacing: 0) {
                    ZStack(alignment: .bottomLeading) {
                        artistImage(url: artist.imgUrl)
                        gradientView()
                        artistInfoView(name: artist.name, birthday: artist.birthday)
                        .padding()
                    }

                    PhotoGrid(presenter: self.presenter)
                        .frame(height: 150)

                    ArtistDetailTabView(artist, artistCredits: self.presenter.artistCredits)
                        .padding(10)
                }
            }
        }
        .onAppear(perform: {
            self.presenter.fetchArtist(artistId: artistId)
        })
    }

    fileprivate func artistImage(url: String) -> some View {
        return CachedAsyncImage(
            url: URL(string: url),
            content: { image in
                image.resizable()
                    .scaledToFill()
                    .frame(height: 400, alignment: .center)
                    .clipped()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(height: 400, alignment: .center)
                    .clipped()
            }
        )
    }

    fileprivate func gradientView() -> some View {
        return Rectangle()
            .fill(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: Color(UIColor.gray).opacity(0.01), location: 0),
                    .init(color: Color(UIColor.gray).opacity(0.8), location: 1)
                ]), startPoint: .top, endPoint: .bottom)
            )
            .frame(height: 200)
            .frame(maxWidth: .infinity, alignment: .trailing)
    }

    fileprivate func artistInfoView(name: String, birthday: String?) -> some View {
        return VStack(alignment: .leading) {
            Text(name)
                .font(.system(size: 30))
                .bold()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            if let birthday = birthday {
                Text(birthday)
                    .font(.system(size: 16))
                    .bold()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)
            }
        }
    }

}

struct PhotoGrid: View {

    @ObservedObject var presenter: ArtistDetailPresenter

    init(presenter: ArtistDetailPresenter) {
        self.presenter = presenter
    }

    var body: some View {

        ScrollView(.horizontal) {
            HStack(spacing: 0) {
                if presenter.artistImages.count > 1 {
                    ZStack {
                        artistGridImage()
                        Rectangle()
                            .foregroundColor(.teal)
                            .opacity(0.7)

                        numberOfImagesLabel()
                        .onTapGesture {
                            // Navigation to artist images
                        }
                    }
                    .padding(.leading, 9)
                }

                LazyHStack(spacing: 0) {
                    ForEach(self.presenter.artistImages.reversed()) { imageEntity in
                        artistImageItem(imageEntity)
                    }
                }
                .padding(.trailing, 8)
            }
        }
    }

    fileprivate func artistGridImage() -> some View {
        return CachedAsyncImage(
            url: URL(string: self.presenter.artistDetail?.imgUrl ?? ""),
            content: { image in
                image.resizable()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
        )
        .scaledToFill()
        .clipped()
    }

    fileprivate func numberOfImagesLabel() -> VStack<TupleView<(some View, some View)>> {
        return VStack {
            Text("\(presenter.artistImages.count)\(presenter.artistImages.count > 1 ? "+" : "")")
                .font(.system(size: 25))
                .bold()
                .minimumScaleFactor(0.7)
                .lineLimit(1)

            Text(ConstantTexts.ButtonTitle.artistDetailScreenPhotoAlbums)
                .font(.system(size: 14))
                .bold()
                .minimumScaleFactor(0.5)
        }
    }

    fileprivate func artistImageItem(_ imageEntity: ReversedCollection<[ArtistImageEntity]>.Element) -> some View {
        return CachedAsyncImage(
            url: URL(string: imageEntity.getPosterUrl()),
            content: { image in
                image.resizable()
            },
            placeholder: {
                Image(systemName: "person.fill")
                    .resizable()
            }
        )
        .scaledToFill()
        .clipped()
        .border(width: 0.4, edges: Edge.allCases, color: .black)
    }
}

struct ArtistDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ArtistDetailView(artistId: 21,
                             presenter: ArtistDetailPresenter(interactor: ArtistDetailInteractorStub())
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
