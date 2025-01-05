//
//  WorklogResponseTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//


//
//  WorklogResponseTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class WorklogResponseTests: XCTestCase {
    func testWorklogResponseDecoding_Success() throws {
        // Arrange
        let json = """
        {
            "id": "10001",
            "issueId": "20002",
            "author": {
                "accountId": "abc123",
                "displayName": "John Doe",
                "active": true
            },
            "updateAuthor": {
                "accountId": "xyz789",
                "displayName": "Jane Smith",
                "active": false
            },
            "comment": "Worked on feature X",
            "started": "2025-01-05T10:00:00Z",
            "timeSpent": "2h",
            "timeSpentSeconds": 7200
        }
        """.data(using: .utf8)!

        // Act
        let worklogResponse = try JSONDecoder().decode(WorklogResponse.self, from: json)

        // Assert
        XCTAssertEqual(worklogResponse.id, "10001")
        XCTAssertEqual(worklogResponse.issueId, "20002")
        XCTAssertEqual(worklogResponse.author?.accountId, "abc123")
        XCTAssertEqual(worklogResponse.author?.displayName, "John Doe")
        XCTAssertEqual(worklogResponse.author?.active, true)
        XCTAssertEqual(worklogResponse.updateAuthor?.accountId, "xyz789")
        XCTAssertEqual(worklogResponse.updateAuthor?.displayName, "Jane Smith")
        XCTAssertEqual(worklogResponse.updateAuthor?.active, false)
        XCTAssertEqual(worklogResponse.comment, "Worked on feature X")
        XCTAssertEqual(worklogResponse.started, "2025-01-05T10:00:00Z")
        XCTAssertEqual(worklogResponse.timeSpent, "2h")
        XCTAssertEqual(worklogResponse.timeSpentSeconds, 7200)
    }

    func testWorklogResponseDecoding_MissingOptionalFields() throws {
        // Arrange
        let json = """
        {
            "id": "10001",
            "issueId": "20002",
            "author": null,
            "updateAuthor": null,
            "comment": null,
            "started": "2025-01-05T10:00:00Z",
            "timeSpent": "1h",
            "timeSpentSeconds": 3600
        }
        """.data(using: .utf8)!

        // Act
        let worklogResponse = try JSONDecoder().decode(WorklogResponse.self, from: json)

        // Assert
        XCTAssertEqual(worklogResponse.id, "10001")
        XCTAssertEqual(worklogResponse.issueId, "20002")
        XCTAssertNil(worklogResponse.author)
        XCTAssertNil(worklogResponse.updateAuthor)
        XCTAssertNil(worklogResponse.comment)
        XCTAssertEqual(worklogResponse.started, "2025-01-05T10:00:00Z")
        XCTAssertEqual(worklogResponse.timeSpent, "1h")
        XCTAssertEqual(worklogResponse.timeSpentSeconds, 3600)
    }

    func testWorklogResponseDecoding_InvalidJSON() {
        // Arrange
        let invalidJson = """
        {
            "id": 10001, // Invalid type, expected String
            "timeSpent": 2h // Missing quotes around string value
        }
        """.data(using: .utf8)!

        // Act & Assert
        XCTAssertThrowsError(try JSONDecoder().decode(WorklogResponse.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError, "Expected DecodingError but got \(error)")
        }
    }
}
