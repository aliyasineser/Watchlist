import SwiftUI

struct MovieDetailView: View {
    @State var presenter: MovieDetailDefaultPresenter
    @State private var isFavorite = false

    var body: some View {
        Group {
            if presenter.hasLoaded {
                MediaDetailContent(
                    media: presenter.media,
                    date: presenter.media.releaseDate,
                    favoriteStorage: presenter.favoriteStorage,
                    mediaService: MovieService.shared,
                    isFavorite: $isFavorite
                )
            } else if presenter.fetchError != nil {
                ContentUnavailableView(
                    "Title unavailable",
                    systemImage: "film",
                    description: Text("Please try again later.")
                )
            } else {
                ProgressView("Loading title…")
            }
        }
        .navigationTitle(presenter.hasLoaded ? presenter.media.title : "Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await presenter.getMediaDetail() }
        .errorAlert(error: $presenter.fetchError)
    }
}
