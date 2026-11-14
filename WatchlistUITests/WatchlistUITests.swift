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
