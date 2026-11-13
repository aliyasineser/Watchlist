import SwiftUI

struct ArtistsView: View {
    @State var presenter: ArtistDefaultPresenter
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    Text("The people behind your favorites.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 240 : 140), spacing: 16)
                        ],
                        alignment: .leading,
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
                    }
                    if presenter.isLoading {
                        ProgressView("Loading artists…")
                            .frame(maxWidth: .infinity)
                    } else {
                        Button("Load more artists") {
                            Task { await presenter.loadArtists() }
                        }
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Artists")
            .task {
                if presenter.artists.isEmpty { await presenter.loadArtists() }
            }
            .errorAlert(error: $presenter.fetchError)
        }
    }
}
