//
//  HalfTunesTests.swift
//  HalfTunesTests
//
//  Created by Quoc Nguyen on 2018/06/04.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesTests: XCTestCase {

    var sessionUnderTest: URLSession!

    override func setUp() {
        super.setUp()
        sessionUnderTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionUnderTest = nil
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testValidCallToItunesGet200Response() {
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=sontungmtp")
        let promise = expectation(description: "Status code 200")
        // When
        let dataTask = sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            if let sttCode = (response as? HTTPURLResponse)?.statusCode {
                if sttCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(sttCode)")
                }
            }

        }
        dataTask.resume()
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testFailCallToItune() {
        let url = URL(string: "https://itune.apple.com/search?media=music&entity=song&term=sontungmtp")
        let promise = expectation(description: "Status code 200")
        // When
        let dataTask = sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                XCTFail(error.localizedDescription)
                return
            }
            if let sttCode = (response as? HTTPURLResponse)?.statusCode {
                if sttCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(sttCode)")
                }
            }

        }
        dataTask.resume()
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testFailFastCallToItune() {
        let url = URL(string: "https://itune.apple.com/search?media=music&entity=song&term=sontungmtp")
        let promise = expectation(description: "Completion handler invoked")
        var sttCode: Int?
        var responseErr: Error?
        // When
        let dataTask = sessionUnderTest.dataTask(with: url!) { (data, response, error) in
            sttCode = (response as? HTTPURLResponse)?.statusCode
            responseErr = error
            promise.fulfill()
        }
        dataTask.resume()
        waitForExpectations(timeout: 15.0, handler: nil)
        XCTAssertEqual(sttCode, 200)
        XCTAssertNil(responseErr)
    }
}
