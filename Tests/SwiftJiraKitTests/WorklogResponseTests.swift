//
//  WorklogResponseTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-30.
//


import XCTest
@testable import SwiftJiraKit

final class WorklogResponseTests: XCTestCase {
    func testDecoding() throws {
        let json = """
        {
            "id": "1",
            "issueId": "TEST-123",
            "author": {"accountId": "123", "displayName": "John Doe", "active": true},
            "updateAuthor": {"accountId": "123", "displayName": "John Doe", "active": true},
            "started": "2023-01-01T12:00:00.000Z",
            "timeSpent": "1h",
            "timeSpentSeconds": 3600
        }
        """.data(using: .utf8)!

        let response = try JSONDecoder().decode(WorklogResponse.self, from: json)
        XCTAssertEqual(response.id, "1")
        XCTAssertEqual(response.timeSpentSeconds, 3600)
    }
}
