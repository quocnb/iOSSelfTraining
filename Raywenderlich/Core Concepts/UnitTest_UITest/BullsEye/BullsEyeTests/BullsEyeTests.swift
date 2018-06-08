//
//  BullsEyeTests.swift
//  BullsEyeTests
//
//  Created by Quoc Nguyen on 2018/06/04.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import BullsEye

class BullsEyeTests: XCTestCase {

    var gameUnderTest: BullsEyeGame!

    override func setUp() {
        super.setUp()
        gameUnderTest = BullsEyeGame()
        gameUnderTest.startNewGame()
    }
    
    override func tearDown() {
        gameUnderTest = nil
        super.tearDown()
    }
    
    func testScoreIsComputedWhenGuessGTTarget() {
        // Given
        let guess = gameUnderTest.targetValue + 5
        // When
        gameUnderTest.check(guess: guess)
        // Then
        XCTAssertEqual(gameUnderTest.scoreRound, 95, "Score computed from guess is wrong")
    }

    func testScoreComputedWhenGuessLTTarget() {
        let guess = gameUnderTest.targetValue - 5
        // When
        gameUnderTest.check(guess: guess)
        // Then
        XCTAssertEqual(gameUnderTest.scoreRound, 95, "Score computed from guess is wrong")
    }
    
}
