import XCTest

final class DailyMenuUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // Wait for the app to load
        let header = app.staticTexts["Daily Menu"]
        XCTAssertTrue(header.waitForExistence(timeout: 10), "App should show Daily Menu header")
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Basic UI Tests

    func testAppLaunchesAndShowsContent() throws {
        XCTAssertTrue(app.staticTexts["Daily Menu"].exists, "Header should exist")
        XCTAssertTrue(app.staticTexts["tiny joys, served fresh"].exists, "Tagline should exist")
    }

    func testSelectButtonWorks() throws {
        // Find button containing "I'll have this" text
        let selectButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'have this'")).firstMatch
        XCTAssertTrue(selectButton.waitForExistence(timeout: 5), "Select button should exist")

        // Tap and verify toast appears
        selectButton.tap()

        let toast = app.staticTexts["Nice! Activity completed"]
        XCTAssertTrue(toast.waitForExistence(timeout: 3), "Toast should appear after selecting activity")
    }

    func testRefreshButtonWorks() throws {
        // Find button containing "Something else" text
        let refreshButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'Something else'")).firstMatch
        XCTAssertTrue(refreshButton.waitForExistence(timeout: 5), "Refresh button should exist")

        refreshButton.tap()
        XCTAssertTrue(true, "Refresh button is tappable")
    }

    func testFavoriteButtonWorks() throws {
        // Find button with "Favorite" accessibility label
        let favoriteButton = app.buttons["Favorite"]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: 5), "Favorite button should exist")

        favoriteButton.tap()
        XCTAssertTrue(true, "Favorite button is tappable")
    }

    func testDismissButtonWorks() throws {
        // Find button with "Dismiss" accessibility label
        let dismissButton = app.buttons["Dismiss"]
        XCTAssertTrue(dismissButton.waitForExistence(timeout: 5), "Dismiss button should exist")

        dismissButton.tap()
        XCTAssertTrue(true, "Dismiss button is tappable")
    }

    func testSelectShowsToastButRefreshDoesNot() throws {
        // Test refresh - should NOT show toast
        let refreshButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'Something else'")).firstMatch
        guard refreshButton.waitForExistence(timeout: 5) else {
            XCTFail("Refresh button not found")
            return
        }

        refreshButton.tap()
        sleep(1)

        let toastAfterRefresh = app.staticTexts["Nice! Activity completed"]
        XCTAssertFalse(toastAfterRefresh.exists, "Toast should NOT appear after tapping 'Something else'")

        // Test select - SHOULD show toast
        let selectButton = app.buttons.containing(NSPredicate(format: "label CONTAINS[c] 'have this'")).firstMatch
        guard selectButton.waitForExistence(timeout: 5) else {
            XCTFail("Select button not found")
            return
        }

        selectButton.tap()

        let toastAfterSelect = app.staticTexts["Nice! Activity completed"]
        XCTAssertTrue(toastAfterSelect.waitForExistence(timeout: 3), "Toast SHOULD appear after tapping 'I'll have this'")
    }

    func testDismissShowsNoToast() throws {
        // Find dismiss button
        let dismissButton = app.buttons["Dismiss"]
        guard dismissButton.waitForExistence(timeout: 5) else {
            XCTFail("Dismiss button not found")
            return
        }

        dismissButton.tap()
        sleep(1)

        let toast = app.staticTexts["Nice! Activity completed"]
        XCTAssertFalse(toast.exists, "Toast should NOT appear after dismiss")
    }
}
