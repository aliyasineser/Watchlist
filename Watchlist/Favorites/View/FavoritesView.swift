import SwiftUI

struct FavoritesView: View {
    @State var store: WatchLibraryStoreImpl
    @State private var status: WatchStatus?
    @State private var type: MediaType?
    @State private var sort = LibrarySort.dateAdded
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var entries: [WatchEntry] { store.filtered(status: status, type: type, sort: sort) }
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 240 : 140), spacing: 16)]
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    Text("Your next watch. Your favorites. Your ratings.")
                        .font(.subheadline).foregroundStyle(.secondary)
                    filters
                    NavigationLink("Saved artists") { SavedArtistsView() }
                    if store.isLoaded {
                        if entries.isEmpty {
                            ContentUnavailableView(
                                "No saved titles yet", systemImage: "bookmark",
                                description: Text("Save a title from its detail page, or change your filters.")
                            )
                        }
                        titleGrid
                    } else {
                        LoadStateView(
                            isLoading: store.isLoading, hasContent: false, error: store.error,
                            retry: { await store.load() }
                        )
                    }
                }
                .padding(20)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Favorites")
            .task { await store.load() }
            .refreshable { await store.load(); store.retryArtwork() }
        }
    }

    private var filters: some View {
        VStack(alignment: .leading) {
            Picker("Title type", selection: $type) {
                Text("All").tag(MediaType?.none)
                Text("Movies").tag(MediaType?.some(.movie))
                Text("TV").tag(MediaType?.some(.tv))
            }
            .pickerStyle(.segmented)
            .accessibilityIdentifier("favorites.category")
            HStack {
                Picker("Status", selection: $status) {
                    Text("All statuses").tag(WatchStatus?.none)
                    ForEach(WatchStatus.allCases) { Text($0.title).tag(WatchStatus?.some($0)) }
                }
                Spacer()
                Picker("Sort", selection: $sort) {
                    ForEach(LibrarySort.allCases) { Text($0.rawValue).tag($0) }
                }
            }
        }
    }

    private var titleGrid: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 24) {
            ForEach(entries) { entry in
                NavigationLink {
                    SavedTitleDetailView(title: entry.title, store: store)
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        PosterArtwork(url: store.artworkURL(for: entry.title))
                        Text(entry.title.title).font(.headline).lineLimit(2, reservesSpace: true)
                        Text(entry.status.title).font(.caption).foregroundStyle(.secondary)
                        if let rating = entry.personalRating {
                            Label("\(rating) / 10", systemImage: "star.fill").font(.caption)
                        }
                    }
                    .foregroundStyle(.primary)
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("library.entry.\(entry.id)")
            }
        }
    }
}
