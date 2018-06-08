//
//  BullsEyeMockTests.swift
//  BullsEyeMockTests
//
//  Created by Quoc Nguyen on 2018/06/04.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye

class MockUserDefault: UserDefaults {
    var gameStyleChange = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "gameStyle" {
            gameStyleChange += 1

        }
    }
}

class BullsEyeMockTests: XCTestCase {
    var controllerUnderTest: ViewController!
    var mockUserDefault: MockUserDefault!

    override func setUp() {
        super.setUp()
        controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        mockUserDefault = MockUserDefault(suiteName: "testing")
        controllerUnderTest.defaults = mockUserDefault
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        mockUserDefault = nil
        super.tearDown()
    }

    func testGameStyleCanBeChanged() {
        // Given
        let segment = UISegmentedControl()
        // When
        XCTAssertEqual(mockUserDefault.gameStyleChange, 0, "gameStyleChanged should be 0 before sendActions")
        segment.addTarget(controllerUnderTest, action: #selector(ViewController.chooseGameStyle(_:)), for: .valueChanged
        )
        segment.sendActions(for: .valueChanged)
        // Then
        XCTAssertEqual(mockUserDefault.gameStyleChange, 1)
    }
}
