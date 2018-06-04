//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by Quoc Nguyen on 2018/06/04.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {

    var controllerUnderTest: SearchViewController!
    override func setUp() {
        super.setUp()
        controllerUnderTest =  UIStoryboard(
            name: "Main",
            bundle: nil
        ).instantiateInitialViewController() as! SearchViewController
        controllerUnderTest.loadView()
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "data", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=sontungmtp")
        let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
        let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
        controllerUnderTest.defaultSession = sessionMock
    }
    
    override func tearDown() {
        controllerUnderTest = nil
        super.tearDown()
    }

    func testUpateSearchResultParseData() {
        let promise = expectation(description: "Response with status 200")
        XCTAssertEqual(controllerUnderTest.searchResults.count, 0, "searchResults should be empty before the data task runs")
        let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=sontungmtp")!
        let dataTask = controllerUnderTest.defaultSession.dataTask(with: url) { (data, response, error) in
            if let err = error {
                print(err.localizedDescription)
            } else if let sttCode = (response as? HTTPURLResponse)?.statusCode, sttCode == 200 {
                self.controllerUnderTest.updateSearchResults(data)
                promise.fulfill()
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertEqual(self.controllerUnderTest.searchResults.count, 3)
    }

    func test_StartDownload_Performance() {
        let track = Track(name: "Waterloo", artist: "ABBA",
                          previewUrl: "http://a821.phobos.apple.com/us/r30/Music/d7/ba/ce/mzm.vsyjlsff.aac.p.m4a")
        measure {
            self.controllerUnderTest?.startDownload(track)
        }
    }
}
