import SwiftUI

struct MediaCastView: View {
    @State var presenter: MediaCastDefaultPresenter
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 240 : 140), spacing: 16)],
            spacing: 24
        ) {
            ForEach(presenter.artists, id: \.id) { artist in
                NavigationLink {
                    ArtistDetailView(
                        artistId: artist.id,
                        presenter: ArtistDetailDefaultPresenter(interactor: DefaultArtistDetailInteractor())
                    )
                } label: {
                    ArtistItemView(artist: artist)
                }
                .buttonStyle(.plain)
            }
            if presenter.isLoading { ProgressView() }
            if presenter.artists.isEmpty && !presenter.isLoading {
                Text("No cast information available.")
                    .foregroundStyle(.secondary)
            }
        }
        .task { await presenter.loadArtists() }
        .errorAlert(error: $presenter.fetchError)
    }
}
