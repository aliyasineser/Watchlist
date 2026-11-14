import SwiftUI

struct MovieReviewView: View {
    @State var presenter: MediaReviewDefaultPresenter

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(presenter.reviews) { review in
                ReviewItem(review: review)
            }
            LoadStateView(
                isLoading: presenter.isLoading,
                hasContent: !presenter.reviews.isEmpty,
                hasMore: presenter.hasMore,
                error: presenter.fetchError,
                retry: { await presenter.fetchReviews() }
            )
        }
        .task { if presenter.reviews.isEmpty { await presenter.fetchReviews() } }

    }
}
