import SwiftUI

/// Shared routing for list entities and the detail entities returned by Favorites.
struct MediaDestinationView: View {
    let item: Watchable

    var body: some View {
        if item is Movie || item is MovieDetail {
            MovieDetailView(
                presenter: MovieDetailDefaultPresenter(interactor: DefaultMovieDetailInteractor(), id: item.id)
            )
        } else {
            TVSerieDetailView(
                presenter: TVSerieDetailDefaultPresenter(interactor: DefaultTVSerieDetailInteractor(), id: item.id)
            )
        }
    }
}
