import SwiftUI

struct LibraryView: View {
    @State var store: WatchLibraryStoreImpl
    @State var providers: ProviderLibraryPresenterImpl
    @State private var section = LibrarySection.titles
    @State private var status: WatchStatus?
    @State private var type: MediaType?
    @State private var sort = LibrarySort.dateAdded
    @State private var metadataRetry = 0
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var entries: [WatchEntry] { store.filtered(status: status, type: type, sort: sort) }
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: dynamicTypeSize.isAccessibilitySize ? 240 : 140), spacing: 16)]
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker("Library section", selection: $section) {
                    ForEach(LibrarySection.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .accessibilityIdentifier("library.section")
                switch section {
                case .titles: savedTitles
                case .lists: CustomListsView(presenter: CustomListsPresenterImpl(store: store))
                case .artists: SavedArtistsView()
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Library")
            .toolbar {
                if section == .titles {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            ProviderLibraryView(presenter: providers)
                        } label: {
                            Label("Available on my services", systemImage: "play.tv")
                        }
                        .accessibilityIdentifier("library.providers")
                    }
                }
            }
            .task { await store.load() }
        }
    }

    private var savedTitles: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                ViewThatFits(in: .horizontal) {
                    HStack { libraryCounts }
                    VStack(alignment: .leading, spacing: 8) { libraryCounts }
                }
                filters
                if store.isLoaded {
                    if entries.isEmpty {
                        ContentUnavailableView(
                            "No saved titles yet", systemImage: "bookmark",
                            description: Text("Save titles from their details, or change the filters above.")
                        )
                    }
                    titleGrid
                } else {
                    LoadStateView(isLoading: store.isLoading, hasContent: false, error: store.error,
                                  retry: { await store.load() })
                }
            }
            .padding(20)
        }
        .refreshable {
            await store.load()
            store.resetMetadataFailures()
            store.retryArtwork()
            metadataRetry += 1
        }
    }

    @ViewBuilder
    private var libraryCounts: some View {
        Text("\(store.entries.count) saved titles").font(.subheadline.weight(.semibold))
        Label("\(store.entries.filter { $0.status == .watching }.count) watching", systemImage: "play.circle")
            .font(.caption).foregroundStyle(.secondary)
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
                .task(id: metadataRetry) { await store.hydrateMetadata(for: entry.id) }
            }
        }
    }
}

private enum LibrarySection: String, CaseIterable, Identifiable {
    case titles = "Titles"
    case lists = "Lists"
    case artists = "Artists"
    var id: Self { self }
}
