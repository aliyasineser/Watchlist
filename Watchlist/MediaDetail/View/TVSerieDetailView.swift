import SwiftUI

struct TVSerieDetailView: View {
    @State var presenter: TVSerieDetailDefaultPresenter
    @State private var isFavorite = false

    var body: some View {
        Group {
            if presenter.hasLoaded {
                MediaDetailContent(
                    media: presenter.media,
                    date: presenter.media.firstAirDate,
                    favoriteStorage: presenter.favoriteStorage,
                    mediaService: TVService.shared,
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
