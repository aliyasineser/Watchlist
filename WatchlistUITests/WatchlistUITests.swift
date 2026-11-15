import XCTest

final class WatchlistUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_rootTabsNavigateOffline() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()

        XCTAssertTrue(app.navigationBars["Discover"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Search"].tap()
        XCTAssertTrue(app.navigationBars["Search"].waitForExistence(timeout: 5))
        app.buttons["search.browseArtists"].tap()
        XCTAssertTrue(app.navigationBars["Artists"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Library"].tap()
        XCTAssertTrue(app.navigationBars["Library"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Discover"].tap()
        XCTAssertTrue(app.navigationBars["Discover"].exists)
    }

    func testContinueWatchingCheckOffAndUndoOffline() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        let mark = app.buttons["continue.mark.tv-1"]
        XCTAssertTrue(mark.waitForExistence(timeout: 5))
        mark.tap()
        XCTAssertTrue(app.staticTexts["Next: S1 E2"].waitForExistence(timeout: 5))
        app.buttons["continue.undo"].tap()
        XCTAssertTrue(app.staticTexts["Next: S1 E1"].waitForExistence(timeout: 5))
    }

    func testCreateCustomListAndAddSavedTitleOffline() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Library"].tap()
        app.segmentedControls["library.section"].buttons["Lists"].tap()
        app.buttons["lists.create"].tap()
        let name = app.textFields["lists.name"]
        XCTAssertTrue(name.waitForExistence(timeout: 5))
        name.tap()
        name.typeText("Movie night")
        app.buttons["lists.save"].tap()
        let list = app.staticTexts["Movie night"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        list.tap()
        app.buttons["lists.addTitles"].tap()
        let selected = app.switches["list.select.movie-1"]
        XCTAssertTrue(selected.waitForExistence(timeout: 5))
        selected.tap()
        app.buttons["Done"].tap()
        XCTAssertTrue(app.descendants(matching: .any)["list.member.movie-1"].waitForExistence(timeout: 5))
    }

    func testChooseTogetherCompletesOfflineRound() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Discover"].tap()
        let together = app.buttons["library.together"]
        if !together.isHittable { app.swipeUp() }
        together.tap()
        app.buttons["together.select.movie-1"].tap()
        let show = app.buttons["together.select.tv-1"]
        if !show.isHittable { app.swipeUp() }
        show.tap()
        let start = app.buttons["together.start"]
        if !start.isHittable { app.swipeUp() }
        start.tap()
        app.buttons["together.interested"].tap()
        app.buttons["together.skip"].tap()
        let next = app.buttons["together.nextViewer"]
        XCTAssertTrue(next.waitForExistence(timeout: 5))
        XCTAssertFalse(app.staticTexts["Your mutual matches"].exists)
        next.tap()
        app.buttons["together.interested"].tap()
        XCTAssertTrue(app.staticTexts["Title 2 of 2"].waitForExistence(timeout: 5))
        app.buttons["together.interested"].tap()
        XCTAssertTrue(app.staticTexts["Your mutual matches"].waitForExistence(timeout: 5))
        app.buttons["together.shuffle"].tap()
        XCTAssertTrue(app.buttons["together.pick"].waitForExistence(timeout: 5))
    }

    func test_favoritesHasEmptyState() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        app.tabBars.buttons["Library"].tap()
        XCTAssertTrue(app.staticTexts["No saved titles yet"].waitForExistence(timeout: 5))
    }

    func testToolsLiveInTheirNewHomesWithoutNetworkOrPermissionPrompts() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        app.tabBars.buttons["Account"].tap()
        app.buttons["library.backup"].tap()
        XCTAssertTrue(app.navigationBars["Backup"].waitForExistence(timeout: 5))
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["account.services"].tap()
        XCTAssertTrue(app.navigationBars["My streaming services"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Library"].tap()
        XCTAssertFalse(app.buttons["library.tonight"].exists)
        XCTAssertFalse(app.buttons["library.together"].exists)
        app.buttons["library.providers"].tap()
        XCTAssertTrue(app.navigationBars["Available to watch"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Upcoming"].tap()
        XCTAssertTrue(app.navigationBars["Upcoming"].waitForExistence(timeout: 5))
        let hideTitles = app.switches["Hide titles in notifications"]
        XCTAssertTrue(hideTitles.waitForExistence(timeout: 5))
        hideTitles.tap()
        XCTAssertEqual(hideTitles.value as? String, "0")
        app.buttons["Manage followed titles"].tap()
        XCTAssertTrue(app.navigationBars["Followed titles"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.alerts.firstMatch.exists)
    }

    func testICloudRequiresExplicitConfirmationBeforeSync() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-icloud-confirm"]
        app.launch()
        app.tabBars.buttons["Account"].tap()
        XCTAssertTrue(app.staticTexts["iCloud connected"].waitForExistence(timeout: 5))
        let sync = app.switches["account.sync"]
        sync.tap()
        let confirm = app.buttons["Merge my library with this iCloud account"]
        XCTAssertTrue(confirm.waitForExistence(timeout: 5))
        confirm.tap()
        let enabled = expectation(for: NSPredicate(format: "value == %@", "1"), evaluatedWith: sync)
        wait(for: [enabled], timeout: 5)
    }

    func testSignedOutICloudShowsSystemAccountGuidance() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-icloud-signed-out"]
        app.launch()
        app.tabBars.buttons["Account"].tap()
        XCTAssertTrue(app.staticTexts["Sign in to iCloud"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.switches["account.sync"].value as? String, "0")
    }

    func testRootScreensInLightAppearance() {
        captureRootScreens(arguments: ["--ui-testing", "--ui-testing-favorites"])
    }

    func testRootScreensWithLargeTextAndDarkAppearance() {
        captureRootScreens(arguments: ["--ui-testing", "--ui-testing-favorites", "--ui-testing-accessibility"])
    }

    private func captureRootScreens(arguments: [String]) {
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()
        for tab in ["Discover", "Library", "Upcoming", "Account"] {
            app.tabBars.buttons[tab].tap()
            XCTAssertTrue(app.navigationBars[tab].waitForExistence(timeout: 5))
            let screenshot = XCTAttachment(screenshot: app.screenshot())
            screenshot.name = tab
            screenshot.lifetime = .keepAlways
            add(screenshot)
        }
    }

    func testWatchTonightPicksAnOfflineSavedTitle() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Discover"].tap()
        app.buttons["library.tonight"].tap()
        XCTAssertTrue(app.navigationBars["Watch tonight"].waitForExistence(timeout: 5))
        app.buttons["tonight.shuffle"].tap()
        XCTAssertTrue(app.buttons["tonight.pick"].waitForExistence(timeout: 5))
        app.buttons["tonight.pick"].tap()
        XCTAssertTrue(app.navigationBars["Saved title"].waitForExistence(timeout: 5))
    }

    func testEpisodeProgressAndUndoWorkOffline() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Library"].tap()
        app.segmentedControls["favorites.category"].buttons["TV"].tap()
        let series = app.buttons["library.entry.tv-1"]
        XCTAssertTrue(series.waitForExistence(timeout: 5))
        series.tap()
        app.buttons["library.episodes"].tap()
        let pilot = app.buttons["episode.1-1"]
        XCTAssertTrue(pilot.waitForExistence(timeout: 5))
        XCTAssertEqual(pilot.label, "Pilot, not watched")
        pilot.tap()
        let watched = expectation(for: NSPredicate(format: "label == %@", "Pilot, watched"), evaluatedWith: pilot)
        wait(for: [watched], timeout: 5)
        app.buttons["episodes.undo"].tap()
        let undone = expectation(for: NSPredicate(format: "label == %@", "Pilot, not watched"), evaluatedWith: pilot)
        wait(for: [undone], timeout: 5)
    }

    func testLibrarySupportsLargeTextAndDarkAppearance() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites", "--ui-testing-accessibility"]
        app.launch()
        app.tabBars.buttons["Library"].tap()
        let card = app.buttons["library.entry.movie-1"]
        for _ in 0..<5 where !card.isHittable { app.swipeUp() }
        XCTAssertTrue(card.waitForExistence(timeout: 5))
        XCTAssertGreaterThanOrEqual(card.frame.minX - app.frame.minX, 19)
        XCTAssertGreaterThanOrEqual(app.frame.maxX - card.frame.maxX, 19)
        card.tap()
        XCTAssertTrue(app.navigationBars["Saved title"].waitForExistence(timeout: 5))
        let screenshot = XCTAttachment(screenshot: app.screenshot())
        screenshot.lifetime = .keepAlways
        add(screenshot)
    }

    func test_favoritesCardsHaveSideMarginsAndFiltersWork() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Library"].tap()
        let movie = app.buttons["library.entry.movie-1"]
        XCTAssertTrue(movie.waitForExistence(timeout: 5))
        XCTAssertGreaterThanOrEqual(movie.frame.minX - app.frame.minX, 19)
        let secondMovie = app.buttons["library.entry.movie-2"]
        XCTAssertTrue(secondMovie.exists)
        XCTAssertGreaterThanOrEqual(app.frame.maxX - secondMovie.frame.maxX, 19)

        let categories = app.segmentedControls["favorites.category"]
        categories.buttons["TV"].tap()
        let series = app.buttons["library.entry.tv-1"]
        XCTAssertTrue(series.waitForExistence(timeout: 5))
        XCTAssertFalse(movie.exists)
        XCTAssertGreaterThanOrEqual(series.frame.minX - app.frame.minX, 19)
        XCTAssertGreaterThanOrEqual(app.frame.maxX - series.frame.maxX, 19)

        series.tap()
        XCTAssertTrue(app.navigationBars["Saved title"].waitForExistence(timeout: 5))
        app.buttons["library.status"].tap()
        app.buttons["Watched"].tap()
        let changed = expectation(
            for: NSPredicate(format: "label CONTAINS %@", "Watched"),
            evaluatedWith: app.buttons["library.status"]
        )
        wait(for: [changed], timeout: 5)
    }
}
