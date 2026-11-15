import SwiftUI

struct TitleListsView: View {
    let title: SavedTitle
    @State var store: WatchLibraryStoreImpl
    @State private var creating = false
    var body: some View {
        List {
            ForEach(store.customLists) { list in
                Toggle(list.name, isOn: Binding(
                    get: { store.customList(list.id)?.items.contains { $0.titleID == title.id } ?? false },
                    set: { value in Task { await store.setListMembership(value, titleID: title.id, listID: list.id) } }
                ))
                .disabled(store.isSaving || store.entry(for: title) == nil)
            }
            Button("Create a list") { creating = true }
        }
        .navigationTitle("Add to lists")
        .sheet(isPresented: $creating) { CustomListEditorView(store: store) }
        .errorAlert(error: $store.error)
    }
}
