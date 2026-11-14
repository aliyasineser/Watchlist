import SwiftUI

struct EpisodeProgressView: View {
    @State var presenter: EpisodePresenterImpl

    var body: some View {
        List {
            if !presenter.isSaved {
                if presenter.isLoadingCatalog {
                    ProgressView("Loading your library…")
                } else {
                    ContentUnavailableView("Save this show first", systemImage: "bookmark")
                    Button("Save and start tracking") {
                        Task { await presenter.saveAndStartTracking() }
                    }
                    .disabled(!presenter.store.isLoaded || presenter.store.isSaving)
                }
            } else {
                summary
                if !presenter.progress.catalog.isEmpty {
                    Picker("Season", selection: $presenter.selectedSeason) {
                        ForEach(presenter.progress.catalog) { Text($0.name).tag(Int?.some($0.seasonNumber)) }
                    }
                    .disabled(presenter.isLoadingCatalog)
                }
                if let season = presenter.season {
                    Section(season.name) {
                        Text("\(season.episodes.filter { presenter.progress.watchedIDs.contains($0.id) }.count)"
                             + " of \(season.episodes.count) episodes watched")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Button("Mark aired episodes watched") {
                            Task { await presenter.setWatched(ids: Set(season.episodes.map(\.id)), watched: true) }
                        }
                        .disabled(presenter.store.isSaving)
                        ForEach(season.episodes) { episodeRow($0) }
                        if season.episodes.isEmpty { Text("No episodes announced yet.").foregroundStyle(.secondary) }
                    }
                }
                if presenter.isLoadingCatalog || presenter.isLoadingSeason {
                    ProgressView("Loading episodes…")
                }
                if presenter.progress.catalog.isEmpty && !presenter.isLoadingCatalog && presenter.error == nil {
                    Text("No seasons announced yet.")
                }
                Button("Refresh season details online") {
                    Task { await presenter.refresh() }
                }
                .disabled(presenter.isLoadingCatalog || presenter.isLoadingSeason || presenter.store.isSaving)
            }
            if let error = presenter.error {
                Section {
                    Text(error.localizedDescription).foregroundStyle(.secondary)
                    Button("Try again") { Task { await presenter.retry() } }
                        .disabled(presenter.isLoadingCatalog || presenter.isLoadingSeason)
                }
            }
            if let error = presenter.actionError {
                Section {
                    Text(error.localizedDescription).foregroundStyle(.secondary)
                    Button("Dismiss") { presenter.dismissActionError() }
                }
            }
        }
        .navigationTitle("Episode progress")
        .navigationBarTitleDisplayMode(.inline)
        .task { await presenter.loadCatalog() }
        .task(id: presenter.selectedSeason) { await presenter.loadSeason() }
    }

    private var summary: some View {
        Section {
            if let next = presenter.progress.nextEpisode(on: .now) {
                Text("Next: S\(next.seasonNumber) E\(next.episodeNumber) · \(next.name)").font(.headline)
            } else {
                Text(presenter.progress.seasons.isEmpty
                     ? "Download a season to start tracking" : "Caught up with downloaded episodes")
                    .font(.headline)
            }
            Text("Next episode uses downloaded seasons and known air dates. Specials are tracked separately.")
                .font(.footnote).foregroundStyle(.secondary)
            if presenter.canUndo {
                Button("Undo last change") { Task { await presenter.undo() } }
                    .disabled(presenter.store.isSaving)
                    .accessibilityIdentifier("episodes.undo")
            }
        }
    }

    private func episodeRow(_ episode: EpisodeRecord) -> some View {
        let watched = presenter.progress.watchedIDs.contains(episode.id)
        return Button {
            Task { await presenter.setWatched(ids: [episode.id], watched: !watched) }
        } label: {
            HStack {
                Image(systemName: watched ? "checkmark.circle.fill" : "circle")
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(episode.episodeNumber). \(episode.name)")
                    Text(episode.airDate ?? "Air date unknown").font(.caption).foregroundStyle(.secondary)
                }
            }
            .foregroundStyle(.primary)
        }
        .disabled(presenter.store.isSaving || (!watched && !episode.hasAired(on: .now)))
        .accessibilityLabel("\(episode.name), \(watched ? "watched" : "not watched")")
        .accessibilityIdentifier("episode.\(episode.id)")
    }
}
