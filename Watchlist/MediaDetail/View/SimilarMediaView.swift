import SwiftUI

struct SimilarMediaView: View {
    @State var presenter: MediaSimilarDefaultPresenter

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(presenter.media, id: \.id) { media in
                MediaListItemView(mediaListItem: media)
            }
            LoadStateView(
                isLoading: presenter.isLoading,
                hasContent: !presenter.media.isEmpty,
                hasMore: presenter.hasMore,
                error: presenter.fetchError,
                retry: { await presenter.fetchSimilar() }
            )
        }
        .task { if presenter.media.isEmpty { await presenter.fetchSimilar() } }

    }
}
