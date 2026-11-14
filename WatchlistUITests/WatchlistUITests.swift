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
        app.tabBars.buttons["Artists"].tap()
        XCTAssertTrue(app.navigationBars["Artists"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.navigationBars["Favorites"].waitForExistence(timeout: 5))
        app.tabBars.buttons["Discover"].tap()
        XCTAssertTrue(app.navigationBars["Discover"].exists)
    }

    func test_favoritesHasEmptyState() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing"]
        app.launch()
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.staticTexts["No saved titles yet"].waitForExistence(timeout: 5))
    }

    func testWatchTonightPicksAnOfflineSavedTitle() {
        let app = XCUIApplication()
        app.launchArguments = ["--ui-testing", "--ui-testing-favorites"]
        app.launch()
        app.tabBars.buttons["Favorites"].tap()
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
        app.tabBars.buttons["Favorites"].tap()
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
        app.tabBars.buttons["Favorites"].tap()
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
        app.tabBars.buttons["Favorites"].tap()
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
