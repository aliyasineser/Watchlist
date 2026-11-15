import SwiftUI

struct WatchStatusControl: View {
    let title: SavedTitle
    private let refreshMetadata: Bool
    @State private var store: WatchLibraryStoreImpl
    @State private var confirmRemoval = false

    init(title: SavedTitle, store: WatchLibraryStoreImpl? = nil, refreshMetadata: Bool = false) {
        self.title = title
        self.refreshMetadata = refreshMetadata
        _store = State(initialValue: store ?? .shared)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let entry = store.entry(for: title) {
                Menu {
                    ForEach(WatchStatus.allCases) { status in
                        Button(status.title) { Task { await store.setStatus(status, for: title) } }
                    }
                    Button("Remove from library", role: .destructive) {
                        confirmRemoval = true
                    }
                } label: {
                    Label(entry.status.title, systemImage: "checkmark.circle.fill")
                }
                .accessibilityIdentifier("library.status")
                Picker("My rating", selection: Binding(
                    get: { entry.personalRating ?? 0 },
                    set: { value in Task { await store.setRating(value == 0 ? nil : value, for: title) } }
                )) {
                    Text("Not rated").tag(0)
                    ForEach(1...10, id: \.self) { Text("\($0) / 10").tag($0) }
                }
            } else {
                Button {
                    Task { await store.setStatus(.wantToWatch, for: title) }
                } label: {
                    Label("Want to watch", systemImage: "plus.circle.fill")
                }
                .accessibilityIdentifier("library.add")
            }
            if !store.isLoaded && !store.isLoading {
                Button("Retry loading library") { Task { await store.load() } }
            }
        }
        .buttonStyle(.bordered)
        .disabled(store.isSaving || store.isLoading)
        .task {
            await store.load()
            if refreshMetadata { await store.refreshMetadata(title) }
        }
        .confirmationDialog("Remove this title from your library and all custom lists?",
                            isPresented: $confirmRemoval, titleVisibility: .visible) {
            Button("Remove title and its list notes", role: .destructive) { Task { await store.remove(title) } }
        }
        .errorAlert(error: $store.error)
    }
}
