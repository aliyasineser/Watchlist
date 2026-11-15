import XCTest
@testable import Watchlist

@MainActor
final class AccountTests: XCTestCase {
    func testIdentityPolicyRequiresConfirmationForNewOrChangedAccount() throws {
        let policy = ICloudIdentityPolicy()
        XCTAssertTrue(policy.needsConfirmation(current: "A", confirmed: nil))
        XCTAssertFalse(policy.needsConfirmation(current: "A", confirmed: "A"))
        XCTAssertTrue(policy.needsConfirmation(current: "B", confirmed: "A"))
        XCTAssertThrowsError(try policy.validatedIdentifier(.init(connection: .signedOut, identifier: nil,
                                                                 needsConfirmation: false)))
        XCTAssertThrowsError(try policy.validatedIdentifier(.init(connection: .available, identifier: "B",
                                                                 needsConfirmation: true)))
        XCTAssertEqual(try policy.validatedIdentifier(.init(connection: .available, identifier: "A",
                                                            needsConfirmation: false)), "A")
    }

    func testSyncCannotStartUntilUserConfirmsCurrentAccount() async {
        let context = await context()
        let original = context.transfer.store.document
        await context.presenter.setSyncEnabled(true)
        XCTAssertFalse(context.transfer.syncEnabled)
        XCTAssertEqual(context.presenter.confirmationIdentifier, "A")
        let before = await context.cloud.calls
        XCTAssertEqual(before, 0)
        await context.presenter.confirmAndSync("A")
        XCTAssertTrue(context.transfer.syncEnabled)
        let after = await context.cloud.calls
        XCTAssertEqual(after, 1)
        XCTAssertEqual(context.transfer.store.document, original)
        XCTAssertNotNil(context.transfer.lastSync)
    }

    func testChangedAccountWhileDialogIsOpenDoesNotMergeOrEraseLocalData() async {
        let context = await context()
        let original = context.transfer.store.document
        await context.presenter.setSyncEnabled(true)
        await context.account.change(to: "B")
        await context.presenter.confirmAndSync("A")
        XCTAssertFalse(context.transfer.syncEnabled)
        XCTAssertNotNil(context.presenter.error)
        let calls = await context.cloud.calls
        XCTAssertEqual(calls, 0)
        XCTAssertEqual(context.transfer.store.document, original)
    }

    func testSignedOutAccountKeepsLocalLibraryAndPausesSync() async {
        let context = await context()
        let original = context.transfer.store.document
        await context.account.change(to: nil)
        context.transfer.syncEnabled = true
        await context.presenter.refresh()
        XCTAssertEqual(context.presenter.account?.connection, .signedOut)
        XCTAssertFalse(context.transfer.syncEnabled)
        await context.presenter.setSyncEnabled(true)
        XCTAssertFalse(context.transfer.syncEnabled)
        XCTAssertEqual(context.transfer.store.document, original)
    }

    func testAutomaticSyncPausesOnAccountConfirmationError() async {
        let defaults = defaults("AccountBlocked")
        let store = WatchLibraryStoreImpl(repository: AccountRepository(), artwork: AccountArtwork())
        await store.load()
        let cloud = AccountCloudMock(blocked: true)
        let transfer = LibraryTransferPresenterImpl(store: store, cloud: cloud, preferences: defaults)
        transfer.syncEnabled = true
        await transfer.sync()
        XCTAssertFalse(transfer.syncEnabled)
        XCTAssertNotNil(transfer.error)
        XCTAssertNil(transfer.lastSync)
        XCTAssertEqual(store.entries.count, 1)
    }

    private func context() async -> AccountTestContext {
        let defaults = defaults("AccountTests")
        let store = WatchLibraryStoreImpl(repository: AccountRepository(), artwork: AccountArtwork())
        await store.load()
        let cloud = AccountCloudMock()
        let transfer = LibraryTransferPresenterImpl(store: store, cloud: cloud, preferences: defaults)
        let account = AccountServiceMock()
        let preferences = ProviderPreferencesImpl(defaults: defaults)
        let subscriptions = SubscriptionPresenterImpl(preferences: preferences, service: AccountCatalogMock())
        let presenter = AccountPresenterImpl(transfer: transfer, service: account, providerPreferences: preferences,
                                            subscriptions: subscriptions)
        return AccountTestContext(presenter: presenter, transfer: transfer, account: account, cloud: cloud)
    }
    private func defaults(_ name: String) -> UserDefaults {
        let defaults = UserDefaults(suiteName: name) ?? .standard
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}

@MainActor
private struct AccountTestContext {
    let presenter: AccountPresenterImpl
    let transfer: LibraryTransferPresenterImpl
    let account: AccountServiceMock
    let cloud: AccountCloudMock
}

private actor AccountServiceMock: ICloudAccountService {
    private var identifier: String? = "A"
    private var confirmed: String?
    func change(to identifier: String?) { self.identifier = identifier }
    func snapshot() async throws -> ICloudAccountSnapshot {
        ICloudAccountSnapshot(connection: identifier == nil ? .signedOut : .available, identifier: identifier,
                              needsConfirmation: identifier != nil && identifier != confirmed)
    }
    func confirmAccount(_ expectedIdentifier: String) async throws {
        guard identifier == expectedIdentifier else { throw ICloudAccountError.changed }
        confirmed = identifier
    }
    func validatedIdentifier() async throws -> String {
        try ICloudIdentityPolicy().validatedIdentifier(await snapshot())
    }
}

private actor AccountCloudMock: LibraryCloudService {
    private(set) var calls = 0
    private let blocked: Bool
    init(blocked: Bool = false) { self.blocked = blocked }
    func exchange(_ local: WatchLibraryDocument) async throws -> WatchLibraryDocument {
        calls += 1
        if blocked { throw ICloudAccountError.confirmationRequired }
        return local
    }
}

private actor AccountRepository: WatchLibraryRepository {
    func load() async throws -> WatchLibraryDocument {
        let title = SavedTitle(tmdbID: 1, mediaType: .movie, title: "My movie")
        return WatchLibraryDocument(importedFavorites: true, entries: [
            WatchEntry(title: title, status: .watching, addedAt: .distantPast, updatedAt: .distantPast)
        ])
    }
    func save(_ document: WatchLibraryDocument) async throws { }
}

private struct AccountArtwork: ArtworkCache {
    func localURL(for id: String) -> URL? { nil }
    func cache(remoteURL: URL, id: String) async throws { }
    func remove(id: String) async { }
}

@MainActor
private struct AccountCatalogMock: ProviderCatalogService {
    func providers(region: String, force: Bool) async throws -> ProviderCatalog {
        ProviderCatalog(providers: [], isStale: false)
    }
}
