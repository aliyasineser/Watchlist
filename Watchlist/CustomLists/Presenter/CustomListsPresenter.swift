import Foundation
import Observation

@MainActor
@Observable
final class CustomListsPresenterImpl {
    let store: WatchLibraryStoreImpl
    init(store: WatchLibraryStoreImpl) { self.store = store }
    var lists: [CustomWatchList] { store.customLists }
    func entries(in list: CustomWatchList) -> [WatchEntry] {
        let entries = Dictionary(uniqueKeysWithValues: store.entries.map { ($0.id, $0) })
        return list.items.compactMap { entries[$0.titleID] }
    }
}
