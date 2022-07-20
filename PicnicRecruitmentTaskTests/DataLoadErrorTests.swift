//
//  DataLoadErrorTests.swift
//  PicnicRecruitmentTaskTests
//
//  Created by Jayesh Kawli on 7/11/22.
//

import XCTest

@testable import PicnicRecruitmentTask

final class DataLoadErrorTests: XCTestCase {

    func testThatDataLoadErrorEnumReturnsCorrectErrorDescription() {
        XCTAssertEqual(DataLoadError.badURL.errorMessageString(), "Invalid URL encountered. Please enter the valid URL and try again")
        XCTAssertEqual(DataLoadError.genericError("Something went wrong").errorMessageString(), "Something went wrong")
        XCTAssertEqual(DataLoadError.noData.errorMessageString(), "No data received from the server. Please try again later")
        XCTAssertEqual(DataLoadError.malformedContent.errorMessageString(), "Received malformed content. Error may have been logged on the server to investigate further")
        XCTAssertEqual(DataLoadError.invalidResponseCode(400).errorMessageString(), "Server returned invalid response code. Expected between the range 200-299. Server returned 400")
        XCTAssertEqual(DataLoadError.decodingError("Key image_data not found").errorMessageString(), "Key image_data not found")
        
    }
}
