import SwiftUI

struct TVSerieDetailView: View {
    @State var presenter: TVSerieDetailDefaultPresenter

    var body: some View {
        Group {
            if presenter.hasLoaded {
                MediaDetailContent(
                    media: presenter.media,
                    date: presenter.media.firstAirDate,
                    mediaService: TVService.shared
                )
            } else {
                LoadStateView(
                    isLoading: presenter.isLoading,
                    hasContent: false,
                    error: presenter.fetchError,
                    emptyMessage: "Title unavailable",
                    retry: { await presenter.getMediaDetail() }
                )
            }
        }
        .navigationTitle(presenter.hasLoaded ? presenter.media.title : "Details")
        .navigationBarTitleDisplayMode(.inline)
        .task { await presenter.getMediaDetail() }

    }
}
