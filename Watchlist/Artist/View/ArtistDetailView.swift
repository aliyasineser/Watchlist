import SwiftUI

struct ArtistDetailView: View {
    @State var presenter: ArtistDetailDefaultPresenter
    let artistId: Int
    @State private var isFavorite = false

    init(artistId: Int, presenter: ArtistDetailDefaultPresenter) {
        self.artistId = artistId
        self.presenter = presenter
    }

    var body: some View {
        ScrollView {
            if let artist = presenter.artistDetail {
                VStack(alignment: .leading, spacing: 24) {
                    profileHeader(artist)
                    if !presenter.artistImages.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            CatalogSectionHeader(title: "Photos", count: presenter.artistImages.count)
                            PhotoGrid(presenter: presenter)
                        }
                    }
                    ArtistDetailTabView(
                        artistDetail: artist,
                        artistMovieCredits: presenter.artistMovieCredits,
                        artistTVSerieCredits: presenter.artistTVSerieCredits
                    )
                }
                .padding(20)
            } else if presenter.isLoading {
                ProgressView("Loading artist…")
                    .frame(maxWidth: .infinity, minHeight: 240)
            } else {
                ContentUnavailableView("Artist unavailable", systemImage: "person.crop.rectangle")
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(presenter.artistDetail?.name ?? "Artist")
        .navigationBarTitleDisplayMode(.inline)
        .task(id: artistId) { await presenter.fetchArtist(artistId: artistId) }
        .errorAlert(error: $presenter.fetchError)
    }

    private func profileHeader(_ artist: ArtistDetail) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            PosterArtwork(url: artist.getPosterUrl(), aspectRatio: 4 / 5, symbol: "person.crop.rectangle")
                .frame(maxWidth: 260)
                .frame(maxWidth: .infinity)
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(artist.name)
                        .font(.title.weight(.bold))
                        .fixedSize(horizontal: false, vertical: true)
                    if let department = artist.knownForDepartment {
                        Text(department)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    if let birthday = artist.birthday {
                        Label(birthday, systemImage: "birthday.cake")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer(minLength: 0)
                FavoriteButton(
                    favoriteStorage: presenter.favoriteStorage,
                    isFavorite: $isFavorite,
                    id: artist.id,
                    title: artist.name
                )
            }
        }
        .padding(20)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 24))
    }
}

struct PhotoGrid: View {
    let presenter: ArtistDetailDefaultPresenter

    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 12) {
                ForEach(presenter.artistImages.reversed(), id: \.filePath) { photo in
                    PosterArtwork(url: photo.getPosterUrl(), aspectRatio: 4 / 5, symbol: "photo")
                        .frame(width: 112)
                }
            }
        }
        .scrollIndicators(.hidden)
    }
}
