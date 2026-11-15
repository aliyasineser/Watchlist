import SwiftUI

struct CustomListDetailView: View {
    let listID: String
    @State var store: WatchLibraryStoreImpl
    @State private var adding = false
    @State private var editing = false
    @State private var noteDraft: ListNoteDraft?
    private var list: CustomWatchList? { store.customList(listID) }

    var body: some View {
        List {
            if let list {
                if !list.notes.isEmpty { Text(list.notes).foregroundStyle(.secondary) }
                ForEach(list.items) { item in
                    if let entry = store.entries.first(where: { $0.id == item.titleID }) {
                        VStack(alignment: .leading, spacing: 8) {
                            NavigationLink(entry.title.title) {
                                SavedTitleDetailView(title: entry.title, store: store)
                            }
                            Button(item.notes.isEmpty ? "Add a note" : item.notes) {
                                noteDraft = ListNoteDraft(
                                    titleID: item.titleID, title: entry.title.title, notes: item.notes
                                )
                            }
                            .buttonStyle(.borderless)
                            .font(.subheadline)
                            .lineLimit(3)
                        }
                        .accessibilityIdentifier("list.member.\(entry.id)")
                    }
                }
                .onMove { from, destination in
                    let expected = list.items.map(\.titleID)
                    Task { await store.moveListItems(listID, from: from, to: destination, expected: expected) }
                }
                .onDelete { offsets in
                    let ids = offsets.compactMap { list.items.indices.contains($0) ? list.items[$0].titleID : nil }
                    Task {
                        for id in ids { await store.setListMembership(false, titleID: id, listID: listID) }
                    }
                }
                if list.items.isEmpty { Text("Add saved titles to start your list.").foregroundStyle(.secondary) }
            } else { ContentUnavailableView("List no longer available", systemImage: "rectangle.stack") }
        }
        .navigationTitle(list?.name ?? "Custom list")
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button("Add titles", systemImage: "plus") { adding = true }.accessibilityIdentifier("lists.addTitles")
                Button("Edit list", systemImage: "pencil") { editing = true }
                EditButton()
            }
        }
        .disabled(store.isSaving || list == nil)
        .sheet(isPresented: $adding) { ListTitlePickerView(listID: listID, store: store) }
        .sheet(isPresented: $editing) { CustomListEditorView(store: store, list: list) }
        .sheet(item: $noteDraft) { draft in ListNoteEditorView(draft: draft, listID: listID, store: store) }
        .errorAlert(error: $store.error)
    }
}

struct ListTitlePickerView: View {
    let listID: String
    @State var store: WatchLibraryStoreImpl
    @Environment(\.dismiss) private var dismiss
    @State private var query = ""
    var body: some View {
        NavigationStack {
            List(store.entries.filter {
                query.isEmpty || $0.title.title.localizedCaseInsensitiveContains(query)
            }) { entry in
                Toggle(entry.title.title, isOn: Binding(
                    get: { store.customList(listID)?.items.contains { $0.titleID == entry.id } ?? false },
                    set: { value in Task { await store.setListMembership(value, titleID: entry.id, listID: listID) } }
                ))
                .disabled(store.isSaving)
                .accessibilityIdentifier("list.select.\(entry.id)")
            }
            .searchable(text: $query, prompt: "Search saved titles")
            .navigationTitle("Add saved titles")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button("Done") { dismiss() } } }
            .errorAlert(error: $store.error)
        }
    }
}

struct ListNoteDraft: Identifiable {
    let titleID: String
    let title: String
    let notes: String
    var id: String { titleID }
}

struct ListNoteEditorView: View {
    let draft: ListNoteDraft
    let listID: String
    @State var store: WatchLibraryStoreImpl
    @State private var notes = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            Form { TextField("Your note", text: $notes, axis: .vertical).lineLimit(5...12) }
                .navigationTitle(draft.title)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Save") {
                            Task {
                                if await store.setListItemNote(notes, titleID: draft.titleID,
                                                               listID: listID, expected: draft.notes) { dismiss() }
                            }
                        }
                        .disabled(store.isSaving)
                    }
                }
                .onAppear { notes = draft.notes }
                .errorAlert(error: $store.error)
        }
    }
}
