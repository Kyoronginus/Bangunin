//
//  BanguninUITests.swift
//  BanguninUITests
//
//  Created by Tohru Djunaedi Sato on 04/09/26.
//

import XCTest

final class BanguninUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // empty state for searchBar
    @MainActor
    func test_searchBar_withInvalidString_showsNoResults() throws {
        let app = XCUIApplication()
        app.launch()

        // 1. Navigate to Add alarm screen (tap the '+' button)
        let addButton = app.buttons["Add"]
        if !addButton.exists {
            // Sometimes systemName: "plus" is just labeled "Add" in accessibility.
            // If not, we can find it as the last button in the navigation bar.
            XCTAssertTrue(app.navigationBars.buttons.count > 0, "Navigation bar should have buttons")
        }
        addButton.tap()

        // 2. Press "Turun di" (Destination Station)
        // SwiftUI merges the text in the HStack for the button's accessibility label.
        let turunDiButton = app.buttons.containing(.staticText, identifier: "Turun di").firstMatch
        XCTAssertTrue(turunDiButton.waitForExistence(timeout: 2.0), "Turun di button should appear")
        turunDiButton.tap()

        // 3. Enter random strings in the searchBar
        let searchBar = app.searchFields["Search"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 2.0), "Search bar should appear")
        searchBar.tap()
        searchBar.typeText("InvalidStation123xyz")

        // 4. Verify default case (empty list / no stations found)
        // The list should have 0 cells.
        let cellsCount = app.cells.count
        XCTAssertEqual(cellsCount, 0, "List should be empty when searching for an invalid string")
    }
}
