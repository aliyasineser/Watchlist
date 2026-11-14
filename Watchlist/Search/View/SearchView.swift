import SwiftUI

struct SearchView: View {
    @State var presenter: SearchPresenterImpl

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 16) {
                    Picker("Search category", selection: $presenter.category) {
                        ForEach(SearchCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }
                    .pickerStyle(.segmented)
                    if presenter.normalizedQuery.isEmpty {
                        recentSearches
                    } else {
                        ForEach(presenter.results) { result in
                            NavigationLink {
                                destination(result)
                            } label: {
                                resultRow(result)
                            }
                            .buttonStyle(.plain)
                        }
                        LoadStateView(
                            isLoading: presenter.isLoading,
                            hasContent: !presenter.results.isEmpty,
                            hasMore: presenter.hasMore,
                            error: presenter.error,
                            emptyMessage: "No matching results. Try another title or name.",
                            retry: { await presenter.retry() }
                        )
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Search")
            .searchable(text: $presenter.query, prompt: "Movies, TV shows, artists")
            .task(id: presenter.taskID) { await presenter.search() }
        }
    }

    private var recentSearches: some View {
        VStack(alignment: .leading, spacing: 16) {
            if presenter.recentQueries.isEmpty {
                ContentUnavailableView("Find your next favorite", systemImage: "magnifyingglass")
            } else {
                HStack {
                    CatalogSectionHeader(title: "Recent searches")
                    Button("Clear") { presenter.clearHistory() }
                }
                ForEach(presenter.recentQueries, id: \.self) { query in
                    Button { presenter.query = query } label: {
                        Label(query, systemImage: "clock")
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }
                }
            }
        }
    }

    private func resultRow(_ result: SearchResult) -> some View {
        HStack(alignment: .top, spacing: 16) {
            PosterArtwork(url: result.imageURL)
                .frame(width: 80)
            VStack(alignment: .leading, spacing: 8) {
                Text(result.title).font(.headline).foregroundStyle(.primary)
                Text(result.category.title).font(.caption).foregroundStyle(.secondary)
                if let overview = result.overview {
                    Text(overview).font(.subheadline).foregroundStyle(.secondary).lineLimit(3)
                }
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 18))
    }

    @ViewBuilder
    private func destination(_ result: SearchResult) -> some View {
        switch result.category {
        case .movies:
            MovieDetailView(presenter: MovieDetailDefaultPresenter(
                interactor: DefaultMovieDetailInteractor(), id: result.tmdbID
            ))
        case .series:
            TVSerieDetailView(presenter: TVSerieDetailDefaultPresenter(
                interactor: DefaultTVSerieDetailInteractor(), id: result.tmdbID
            ))
        case .artists:
            ArtistDetailView(
                artistId: result.tmdbID,
                presenter: ArtistDetailDefaultPresenter(interactor: DefaultArtistDetailInteractor())
            )
        case .all:
            EmptyView()
        }
    }
}
