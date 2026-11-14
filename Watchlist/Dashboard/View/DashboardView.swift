//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI

enum TabViewSection: Hashable {
    case discover
    case artists
    case favorites
    case auth
    case search

    var tag: Int {
        switch self {
        case .discover:
            return 0
        case .artists:
            return 1
        case .favorites:
            return 2
        case .auth:
            return 3
        case .search:
            return 4
        }
    }
}

struct DashboardView: View {
    @State private var searchPresenter: SearchPresenterImpl
    @State private var selectedTab: TabViewSection = .discover
    @State private var discoverPresenter: DiscoverDefaultPresenter
    @State private var artistPresenter: ArtistDefaultPresenter
    @State private var libraryStore: WatchLibraryStoreImpl
    @State private var transfer: LibraryTransferPresenterImpl
    @State private var upcoming: UpcomingPresenterImpl
    @Environment(\.scenePhase) private var scenePhase

    init(dependencies: AppDependencies? = nil) {
        let dependencies = dependencies ?? AppDependenciesImpl()
        _searchPresenter = State(initialValue: dependencies.makeSearchPresenter())
        _discoverPresenter = State(initialValue: dependencies.makeDiscoverPresenter())
        _artistPresenter = State(initialValue: dependencies.makeArtistPresenter())
        let store = dependencies.makeWatchLibraryStore()
        _libraryStore = State(initialValue: store)
        _transfer = State(initialValue: dependencies.makeTransferPresenter(store: store))
        _upcoming = State(initialValue: dependencies.makeUpcomingPresenter(store: store))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Discover", systemImage: Icons.TabBar.discover.rawValue, value: .discover) {
                DiscoverView(presenter: discoverPresenter)
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                SearchView(presenter: searchPresenter)
            }
            Tab("Artists", systemImage: Icons.TabBar.artist.rawValue, value: .artists) {
                ArtistsView(presenter: artistPresenter)
            }
            Tab("Favorites", systemImage: Icons.TabBar.favorites.rawValue, value: .favorites) {
                FavoritesView(store: libraryStore, transfer: transfer, upcoming: upcoming)
            }
        }
        .task(id: libraryStore.revision) {
            await libraryStore.load()
            await reconcileReminders()
            guard transfer.syncEnabled else { return }
            do { try await Task.sleep(for: .seconds(2)) } catch { return }
            await transfer.sync()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task { await reconcileReminders(); await transfer.sync() }
            }
        }
    }
    private func reconcileReminders() async {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") { return }
        #endif
        await ReleaseRemindersImpl.shared.reconcile(store: libraryStore)
    }

}

struct TabItemView: View {

    private let systemName: String
    private let text: String

    init(systemName: String, text: String) {
        self.systemName = systemName
        self.text = text
    }

    var body: some View {
        VStack {
            Image(systemName: self.systemName)
                .renderingMode(.template)
                .foregroundColor(.teal)
            Text(self.text)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
