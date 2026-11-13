import SwiftUI

struct SimilarMediaView: View {
    @State var presenter: MediaSimilarDefaultPresenter

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(presenter.media, id: \.id) { media in
                MediaListItemView(mediaListItem: media)
            }
            if presenter.isLoading {
                ProgressView()
            } else if presenter.media.isEmpty {
                ContentUnavailableView("No similar titles yet", systemImage: "film")
            } else {
                Button("Load more titles") { Task { await presenter.fetchSimilar() } }
                    .buttonStyle(.bordered)
            }
        }
        .task { if presenter.media.isEmpty { await presenter.fetchSimilar() } }
        .errorAlert(error: $presenter.fetchError)
    }
}
