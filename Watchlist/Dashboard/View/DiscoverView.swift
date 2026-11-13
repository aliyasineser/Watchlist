import SwiftUI

struct DiscoverView: View {
    @State var presenter: DiscoverDefaultPresenter

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 28) {
                    Text("Find your next great watch.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 20)
                    if let featured = presenter.popularMovies.first {
                        featuredCard(featured)
                            .padding(.horizontal, 20)
                    }
                    if !presenter.popularMovies.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "Popular movies",
                            sliceItems: presenter.popularMovies,
                            section: .popularMovies
                        )
                    }
                    if !presenter.mostRecentMovies.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "Now playing",
                            sliceItems: presenter.mostRecentMovies,
                            section: .mostRecentMovies
                        )
                    }
                    if !presenter.upcomingMovies.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "Coming soon",
                            sliceItems: presenter.upcomingMovies,
                            section: .comingSoonMovies
                        )
                    }
                    if !presenter.airingTodaySeries.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "On TV today",
                            sliceItems: presenter.airingTodaySeries,
                            section: .airingTodaySeries
                        )
                    }
                    if !presenter.onTheAirSeries.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "On the air",
                            sliceItems: presenter.onTheAirSeries,
                            section: .onTheAirSeries
                        )
                    }
                    if !presenter.topRatedSeries.isEmpty {
                        DiscoverSlice(
                            sliceTitle: "Popular TV",
                            sliceItems: presenter.topRatedSeries,
                            section: .topRatedSeries
                        )
                    }
                    if presenter.isLoading {
                        ProgressView("Finding something great…")
                            .frame(maxWidth: .infinity)
                    } else if isEmpty {
                        ContentUnavailableView {
                            Label("Nothing to discover yet", systemImage: "film")
                        } description: {
                            Text("Try again to load movies and TV shows.")
                        } actions: {
                            Button("Try again") { Task { await presenter.fetchMedia() } }
                                .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Discover")
            .task { if isEmpty { await presenter.fetchMedia() } }
            .errorAlert(error: $presenter.fetchError)
        }
    }

    private var isEmpty: Bool {
        presenter.popularMovies.isEmpty && presenter.mostRecentMovies.isEmpty && presenter.upcomingMovies.isEmpty
            && presenter.airingTodaySeries.isEmpty
            && presenter.onTheAirSeries.isEmpty
            && presenter.topRatedSeries.isEmpty
    }

    private func featuredCard(_ item: Watchable) -> some View {
        NavigationLink {
            MediaDestinationView(item: item)
        } label: {
            VStack(alignment: .leading, spacing: 0) {
                PosterArtwork(url: featuredImageURL(item), aspectRatio: 16 / 9)
                VStack(alignment: .leading, spacing: 8) {
                    Label("IN THE SPOTLIGHT", systemImage: "sparkles")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(Color.accentColor)
                    Text(item.title)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.primary)
                    if let overview = item.overview {
                        Text(overview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Label("Explore title", systemImage: "arrow.right")
                        .font(.subheadline.weight(.semibold))
                        .padding(.top, 4)
                }
                .padding(20)
            }
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
        }
        .buttonStyle(.plain)
    }
    private func featuredImageURL(_ item: Watchable) -> String {
        guard let backdrop = item.backdropPath else { return item.posterUrl }
        return APIConstants.defaultScheme + APIConstants.baseImgUrl + APIConstants.baseImgUrlPath + backdrop
    }
}
