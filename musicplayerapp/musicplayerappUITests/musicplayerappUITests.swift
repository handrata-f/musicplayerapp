//
//  musicplayerappUITests.swift
//  musicplayerappUITests
//
//  Created by Handrata Febrianto on 25/03/25.
//

import XCTest
import Alamofire

final class musicplayerappUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testSearchAndPlaySong() {
        let searchField = app.textFields["textFieldSearch"]
        XCTAssertTrue(searchField.exists, "Search text field should exist")
        
        searchField.tap()
        searchField.typeText("Shape of You")
        app.keyboards.buttons["Return"].tap()
        
        let firstCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 5), "Search results should be displayed")
        
        firstCell.tap()
        
        let playPauseButton = app.buttons["buttonPlayPause"]
        XCTAssertTrue(playPauseButton.exists, "Play/Pause button should exist")
        playPauseButton.tap()
    }
    
    func testPlayPauseFunctionality() {
        let playPauseButton = app.buttons["buttonPlayPause"]
        XCTAssertTrue(playPauseButton.exists, "Play/Pause button should exist")
        
        playPauseButton.tap()
        XCTAssertTrue(playPauseButton.isSelected, "Music should be playing")
        
        playPauseButton.tap()
        XCTAssertFalse(playPauseButton.isSelected, "Music should be paused")
    }
    
    func testNextAndPreviousButtons() {
        let nextButton = app.buttons["buttonNext"]
        let previousButton = app.buttons["buttonPrevious"]
        
        XCTAssertTrue(nextButton.exists, "Next button should exist")
        XCTAssertTrue(previousButton.exists, "Previous button should exist")
        
        nextButton.tap()
        previousButton.tap()
    }
}
