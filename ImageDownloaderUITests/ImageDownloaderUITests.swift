//
//  ImageDownloaderUITests.swift
//  ImageDownloaderUITests
//
//  Created by apple on 17/05/2017.
//
//

import XCTest

class ImageDownloaderUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testCollectionViewCellsExist() {
        XCUIApplication().collectionViews.cells.otherElements.containing(.staticText, identifier:" ").children(matching: .image).element.tap()
    }
    
    func testSavingImage() {
        
        let app = XCUIApplication()
        // look for a specific image - improvement would be to make this dynamic
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"17-04-10 X-T2-543").children(matching: .image).element.tap()
        let saveButton = app.navigationBars["Detail View"].buttons["Save"]
        if saveButton.exists {
            saveButton.tap()
            app.alerts["Save Image"].buttons["OK"].tap()
        } else {
            XCTFail()
        }
    }
    
}
