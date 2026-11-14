import SwiftUI

/// Opens saved metadata immediately, even when the catalog service is unavailable.
struct SavedTitleDetailView: View {
    let title: SavedTitle
    private var currentTitle: SavedTitle { store.entry(for: title)?.title ?? title }
    @State var store: WatchLibraryStoreImpl

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                PosterArtwork(url: store.artworkURL(for: title))
                    .frame(maxWidth: 220).frame(maxWidth: .infinity)
                Text(title.title).font(.title.bold())
                WatchStatusControl(title: currentTitle, store: store)
                if title.mediaType == .tv {
                    NavigationLink("Episode progress") {
                        EpisodeProgressView(presenter: EpisodePresenterImpl(title: currentTitle, store: store))
                    }
                    .accessibilityIdentifier("library.episodes")
                }
                if let overview = currentTitle.overview, !overview.isEmpty {
                    Text(overview).textSelection(.enabled)
                } else {
                    Text("Open full details online to save the story and artwork for next time.")
                        .foregroundStyle(.secondary)
                }
                NavigationLink("Full details online") {
                    if title.mediaType == .movie {
                        MovieDetailView(presenter: MovieDetailDefaultPresenter(
                            interactor: DefaultMovieDetailInteractor(), id: title.tmdbID
                        ))
                    } else {
                        TVSerieDetailView(presenter: TVSerieDetailDefaultPresenter(
                            interactor: DefaultTVSerieDetailInteractor(), id: title.tmdbID
                        ))
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Saved title")
        .navigationBarTitleDisplayMode(.inline)
    }
}
