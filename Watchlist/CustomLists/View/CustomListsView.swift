import SwiftUI

struct CustomListsView: View {
    @State var presenter: CustomListsPresenterImpl
    @State private var creating = false
    @State private var deleting: Set<String> = []
    @State private var confirmDelete = false

    var body: some View {
        List {
            ForEach(presenter.lists) { list in
                NavigationLink {
                    CustomListDetailView(listID: list.id, store: presenter.store)
                } label: {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(list.name).font(.headline)
                        Text("\(list.items.count) titles").font(.caption).foregroundStyle(.secondary)
                        if !list.notes.isEmpty { Text(list.notes).font(.subheadline).lineLimit(2) }
                    }
                }
                .accessibilityIdentifier("customList.\(list.id)")
            }
            .onDelete { offsets in
                deleting = Set(offsets.compactMap {
                    presenter.lists.indices.contains($0) ? presenter.lists[$0].id : nil
                })
                confirmDelete = true
            }
            if presenter.lists.isEmpty {
                ContentUnavailableView("Make it your collection", systemImage: "rectangle.stack",
                                       description: Text("Create lists for moods, friends or your next movie night."))
            }
        }
        .navigationTitle("Custom lists")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New list", systemImage: "plus") { creating = true }
                    .accessibilityIdentifier("lists.create")
            }
        }
        .sheet(isPresented: $creating) { CustomListEditorView(store: presenter.store) }
        .confirmationDialog("Delete these lists? Saved titles stay in your library.",
                            isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete lists", role: .destructive) {
                let ids = deleting
                Task { await presenter.store.deleteLists(ids) }
            }
        }
        .task { await presenter.store.load() }
        .errorAlert(error: Binding(get: { presenter.store.error }, set: { presenter.store.error = $0 }))
    }
}

struct CustomListEditorView: View {
    @State var store: WatchLibraryStoreImpl
    var list: CustomWatchList?
    @State private var name = ""
    @State private var notes = ""
    @State private var original: CustomWatchList?
    @State private var loaded = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                TextField("List name", text: $name).accessibilityIdentifier("lists.name")
                TextField("Notes", text: $notes, axis: .vertical).lineLimit(3...8)
                Text("Up to 80 characters for the name and 2,000 for notes.")
                    .font(.footnote).foregroundStyle(.secondary)
            }
            .navigationTitle(list == nil ? "New list" : "Edit list")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task {
                            let saved = await store.saveList(
                                id: original?.id, name: name, notes: notes, expected: original?.updatedAt
                            )
                            if saved { dismiss() }
                        }
                    }
                    .disabled(store.isSaving || name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .accessibilityIdentifier("lists.save")
                }
            }
            .onAppear {
                guard !loaded else { return }
                original = list
                name = list?.name ?? ""
                notes = list?.notes ?? ""
                loaded = true
            }
            .errorAlert(error: $store.error)
        }
    }
}
