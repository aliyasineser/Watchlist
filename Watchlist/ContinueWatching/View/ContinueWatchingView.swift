import SwiftUI

struct ContinueWatchingView: View {
    @State var presenter: ContinueWatchingPresenterImpl

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if !presenter.items.isEmpty || presenter.canUndo {
                HStack {
                    Text("Continue watching").font(.title2.bold())
                    Spacer()
                    if presenter.canUndo {
                        Button("Undo") { Task { await presenter.undo() } }
                            .disabled(presenter.store.isSaving)
                            .accessibilityIdentifier("continue.undo")
                    }
                }
                .padding(.horizontal, 20)
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .top, spacing: 16) {
                        ForEach(presenter.items) { item in card(item) }
                    }
                    .padding(.horizontal, 20)
                }
                .scrollIndicators(.hidden)
            }
        }
        .task { await presenter.store.load() }
        .errorAlert(error: $presenter.error)
    }

    private func card(_ item: ContinueWatchingItem) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            NavigationLink {
                SavedTitleDetailView(title: item.entry.title, store: presenter.store)
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    PosterArtwork(url: presenter.store.artworkURL(for: item.entry.title)).frame(width: 66)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(item.entry.title.title).font(.headline).lineLimit(2)
                        Text(item.subtitle).font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .foregroundStyle(.primary)
            }
            .buttonStyle(.plain)
            if let action = item.actionTitle {
                Button(action) { Task { await presenter.markWatched(item.id) } }
                    .buttonStyle(.bordered)
                    .disabled(presenter.store.isSaving)
                    .accessibilityIdentifier("continue.mark.\(item.id)")
            }
        }
        .frame(width: 260, alignment: .leading)
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
        .accessibilityIdentifier("continue.card.\(item.id)")
    }
}
