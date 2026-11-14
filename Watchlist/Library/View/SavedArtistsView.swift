import SwiftUI

struct SavedArtistsView: View {
    @State private var artists: [SavedArtist] = []
    @State private var error: Error?

    private struct SavedArtist: Identifiable {
        let id: Int
        let name: String
    }

    var body: some View {
        List {
            ForEach(artists) { artist in
                NavigationLink(artist.name) {
                    ArtistDetailView(
                        artistId: artist.id,
                        presenter: ArtistDetailDefaultPresenter(interactor: DefaultArtistDetailInteractor())
                    )
                }
            }
            if artists.isEmpty {
                ContentUnavailableView("No saved artists", systemImage: "person.crop.circle")
            }
        }
        .navigationTitle("Saved artists")
        .task { load() }
        .refreshable { load() }
        .errorAlert(error: $error)
    }

    private func load() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") { return }
        #endif
        do {
            artists = try FavoriteArtistStorage.shared.fetchArtists().map {
                SavedArtist(id: Int($0.id), name: $0.name ?? "Unknown artist")
            }.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
        } catch { self.error = error }
    }
}
