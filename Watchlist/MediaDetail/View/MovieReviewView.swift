import SwiftUI

struct MovieReviewView: View {
    @State var presenter: MediaReviewDefaultPresenter

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(presenter.reviews) { review in
                ReviewItem(review: review)
            }
            if presenter.isLoading {
                ProgressView()
            } else if presenter.reviews.isEmpty {
                ContentUnavailableView("No reviews yet", systemImage: "text.bubble")
            } else {
                Button("Load more reviews") { Task { await presenter.fetchReviews() } }
                    .buttonStyle(.bordered)
            }
        }
        .task { if presenter.reviews.isEmpty { await presenter.fetchReviews() } }
        .errorAlert(error: $presenter.fetchError)
    }
}
