//
//  WorklogRequestTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-30.
//


import XCTest
@testable import SwiftJiraKit

final class WorklogRequestTests: XCTestCase {
    func testEncoding() throws {
        let request = WorklogRequest(timeSpent: "1h", timeSpentSeconds: 3600, started: "2023-01-01T12:00:00.000Z", comment: "Test", visibility: nil)
        let data = try JSONEncoder().encode(request)
        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

        XCTAssertEqual(json?["timeSpent"] as? String, "1h")
        XCTAssertEqual(json?["timeSpentSeconds"] as? Int, 3600)
    }
}
