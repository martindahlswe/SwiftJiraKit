//
//  APIErrorTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-30.
//


import XCTest
@testable import SwiftJiraKit

final class APIErrorTests: XCTestCase {
    func testEquality() {
        XCTAssertEqual(APIError.invalidResponse, APIError.invalidResponse)
        XCTAssertEqual(APIError.decodingError, APIError.decodingError)
        XCTAssertNotEqual(APIError.invalidResponse, APIError.decodingError)
    }
}
