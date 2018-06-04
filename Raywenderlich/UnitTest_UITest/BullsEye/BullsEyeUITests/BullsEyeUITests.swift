//
//  BullsEyeUITests.swift
//  BullsEyeUITests
//
//  Created by Quoc Nguyen on 2018/06/04.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye

class BullsEyeUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testGameStyleSwitch() {
        // given
        let typeBtn = app/*@START_MENU_TOKEN@*/.segmentedControls.buttons["Type"]/*[[".segmentedControls.buttons[\"Type\"]",".buttons[\"Type\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        let slideBtn = app.segmentedControls.buttons["Slide"]
        let slideLabel = app.staticTexts["Get as close as you can to: "]
        let typeLabel = app.staticTexts["Guess where the slider is: "]
        // then
        if slideBtn.isSelected {
            XCTAssertTrue(slideLabel.exists)
            XCTAssertFalse(typeLabel.exists)

            typeBtn.tap()
            XCTAssertTrue(typeLabel.exists)
            XCTAssertFalse(slideLabel.exists)
        } else if typeBtn.isSelected {
            XCTAssertTrue(typeLabel.exists)
            XCTAssertFalse(slideLabel.exists)

            slideBtn.tap()
            XCTAssertTrue(slideLabel.exists)
            XCTAssertFalse(typeBtn.exists)
        }
    }
}
