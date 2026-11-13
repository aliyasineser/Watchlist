import SwiftUI

struct FavoritesView: View {
    @State private var presenter: FavoritesDefaultPresenter
    @State private var selectedCategory = Category.all
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private enum Category: String, CaseIterable, Identifiable {
        case all = "All"
        case movies = "Movies"
        case series = "TV"
        case artists = "Artists"

        var id: Self { self }
    }

    init(presenter: FavoritesDefaultPresenter) {
        self.presenter = presenter
    }

    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 240 : 140), spacing: 16)]
    }

    private var totalCount: Int {
        presenter.movies.count + presenter.tvSeries.count + presenter.artists.count
    }

    private var visibleCount: Int {
        switch selectedCategory {
        case .all: totalCount
        case .movies: presenter.movies.count
        case .series: presenter.tvSeries.count
        case .artists: presenter.artists.count
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your collection, ready when you are.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Picker("Favorite category", selection: $selectedCategory) {
                            ForEach(Category.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("favorites.category")
                    }

                    if presenter.isLoading && totalCount == 0 {
                        ProgressView("Loading your favorites…")
                            .frame(maxWidth: .infinity, minHeight: 160)
                    } else if visibleCount == 0 {
                        ContentUnavailableView(
                            "No favorites yet",
                            systemImage: "heart",
                            description: Text("Tap the heart on a movie, TV show, or artist to save it here.")
                        )
                        .accessibilityIdentifier("favorites.empty")
                    } else {
                        if selectedCategory == .all || selectedCategory == .movies, !presenter.movies.isEmpty {
                            mediaSection("Movies", items: presenter.movies)
                        }
                        if selectedCategory == .all || selectedCategory == .series, !presenter.tvSeries.isEmpty {
                            mediaSection("TV series", items: presenter.tvSeries)
                        }
                        if selectedCategory == .all || selectedCategory == .artists, !presenter.artists.isEmpty {
                            artistSection
                        }
                    }
                }
                // A single shared inset applies to every category, grid and empty state.
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Favorites")
            .refreshable { await presenter.fetchFavorites() }
            .task { await presenter.fetchFavorites() }
            .errorAlert(error: $presenter.fetchError)
        }
    }

    private func mediaSection(_ title: String, items: [Watchable]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            CatalogSectionHeader(title: title, count: items.count)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
                ForEach(items, id: \.id) { item in
                    NavigationLink {
                        MediaDestinationView(item: item)
                    } label: {
                        MediaPosterCard(item: item)
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("favorites.media.\(title).\(item.id)")
                }
            }
        }
    }

    private var artistSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            CatalogSectionHeader(title: "Artists", count: presenter.artists.count)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
                ForEach(presenter.artists) { artist in
                    NavigationLink {
                        ArtistDetailView(
                            artistId: artist.id,
                            presenter: ArtistDetailDefaultPresenter(interactor: DefaultArtistDetailInteractor())
                        )
                    } label: {
                        VStack(alignment: .leading, spacing: 10) {
                            PosterArtwork(
                                url: artist.getPosterUrl(), aspectRatio: 4 / 5, symbol: "person.crop.rectangle"
                            )
                            Text(artist.name)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(2, reservesSpace: true)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("favorites.artist.\(artist.id)")
                }
            }
        }
    }
}
