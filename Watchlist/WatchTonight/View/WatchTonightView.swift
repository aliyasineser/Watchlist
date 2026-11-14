import SwiftUI

struct WatchTonightView: View {
    @State var presenter: WatchTonightPresenterImpl

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Make tonight a movie night")
                    .font(.title2.bold())
                Text("Choose from your saved titles. The shortlist starts with the ones saved longest ago.")
                    .foregroundStyle(.secondary)
                filters
                if let picked = presenter.picked {
                    Text("Tonight’s pick").font(.headline)
                    suggestion(picked)
                        .accessibilityIdentifier("tonight.pick")
                }
                Button("Pick for me", systemImage: "shuffle") { presenter.pick() }
                    .buttonStyle(.borderedProminent)
                    .disabled(presenter.matches.isEmpty)
                    .accessibilityIdentifier("tonight.shuffle")
                if presenter.excludedForMissingMetadata > 0 {
                    Text("Some titles need more details to match these filters. Open their full details online first.")
                        .font(.footnote).foregroundStyle(.secondary)
                }
                if presenter.matches.isEmpty {
                    ContentUnavailableView(
                        "No matches tonight", systemImage: "moon.stars",
                        description: Text("Try a longer time limit, another genre, or save more unwatched titles.")
                    )
                } else {
                    Text("Your shortlist").font(.headline)
                    ForEach(presenter.shortlist) { suggestion($0) }
                }
            }
            .padding(20)
        }
        .navigationTitle("Watch tonight")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground))
        .task { await presenter.store.load() }
    }

    private var filters: some View {
        VStack {
            Picker("Type", selection: $presenter.filter.mediaType) {
                Text("All").tag(MediaType?.none)
                Text("Movies").tag(MediaType?.some(.movie))
                Text("TV").tag(MediaType?.some(.tv))
            }
            .pickerStyle(.segmented)
            Picker("Available time", selection: $presenter.filter.maximumMinutes) {
                Text("Any length").tag(Int?.none)
                ForEach([30, 60, 90, 120, 180], id: \.self) { Text("Up to \($0) min").tag(Int?.some($0)) }
            }
            Picker("Genre", selection: $presenter.filter.genre) {
                Text("Any genre").tag(String?.none)
                ForEach(presenter.genres, id: \.self) { Text($0).tag(String?.some($0)) }
            }
        }
    }

    private func suggestion(_ entry: WatchEntry) -> some View {
        NavigationLink {
            SavedTitleDetailView(title: entry.title, store: presenter.store)
        } label: {
            HStack(alignment: .top, spacing: 16) {
                PosterArtwork(url: presenter.store.artworkURL(for: entry.title)).frame(width: 80)
                VStack(alignment: .leading, spacing: 8) {
                    Text(entry.title.title).font(.headline)
                    Text(presenter.reason(for: entry)).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
            }
            .foregroundStyle(.primary)
            .padding(12)
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
