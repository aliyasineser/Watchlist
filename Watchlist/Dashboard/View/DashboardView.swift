//
//  DashboardView.swift
//  Watchlist
//
//  Created by Ali Yasin Eser on 12.05.2021.
//

import SwiftUI
import CloudKit
import Combine

enum TabViewSection: Hashable {
    case discover
    case artists
    case favorites
    case auth
    case search
    case upcoming
    case account

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
        case .upcoming:
            return 5
        case .account:
            return 6
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
    @State private var continueWatching: ContinueWatchingPresenterImpl
    @State private var accountPresenter: AccountPresenterImpl
    @State private var providers: ProviderLibraryPresenterImpl
    @Environment(\.scenePhase) private var scenePhase

    init(dependencies: AppDependencies? = nil) {
        let dependencies = dependencies ?? AppDependenciesImpl()
        _searchPresenter = State(initialValue: dependencies.makeSearchPresenter())
        _discoverPresenter = State(initialValue: dependencies.makeDiscoverPresenter())
        _artistPresenter = State(initialValue: dependencies.makeArtistPresenter())
        let store = dependencies.makeWatchLibraryStore()
        _libraryStore = State(initialValue: store)
        let transfer = dependencies.makeTransferPresenter(store: store)
        let account = dependencies.makeAccountPresenter(transfer: transfer)
        _transfer = State(initialValue: transfer)
        _accountPresenter = State(initialValue: account)
        _providers = State(initialValue: dependencies.makeProviderLibraryPresenter(
            store: store, preferences: account.providerPreferences
        ))
        _upcoming = State(initialValue: dependencies.makeUpcomingPresenter(store: store))
        _continueWatching = State(initialValue: ContinueWatchingPresenterImpl(store: store))
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Discover", systemImage: Icons.TabBar.discover.rawValue, value: .discover) {
                DiscoverView(presenter: discoverPresenter, continueWatching: continueWatching)
            }
            Tab("Search", systemImage: "magnifyingglass", value: .search) {
                SearchView(presenter: searchPresenter, artistPresenter: artistPresenter)
            }
            Tab("Library", systemImage: "rectangle.stack.fill", value: .favorites) {
                LibraryView(store: libraryStore, providers: providers)
            }
            Tab("Upcoming", systemImage: "calendar", value: .upcoming) {
                NavigationStack { UpcomingView(presenter: upcoming) }
            }
            Tab("Account", systemImage: "person.crop.circle", value: .account) {
                NavigationStack { AccountView(presenter: accountPresenter) }
            }
        }
        .task(id: libraryStore.revision) {
            await libraryStore.load()
            await reconcileReminders()
            guard transfer.syncEnabled else { return }
            do { try await Task.sleep(for: .seconds(2)) } catch { return }
            await transfer.sync()
        }
        .onReceive(NotificationCenter.default.publisher(for: .CKAccountChanged)) { _ in
            if transfer.syncEnabled || selectedTab == .account { Task { await accountPresenter.refresh() } }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                Task {
                    if transfer.syncEnabled || selectedTab == .account { await accountPresenter.refresh() }
                    await reconcileReminders()
                    await transfer.sync()
                }
            }
        }
    }
    private func reconcileReminders() async {
        #if DEBUG
        if AppRuntime.usesTestDependencies { return }
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
