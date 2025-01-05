//
//  IssueResponseTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//


//
//  IssueResponseTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class IssueResponseTests: XCTestCase {
    func testDecodeIssueResponse_Success() throws {
        // Arrange
        let json = """
        {
            "id": "1001",
            "key": "JIRA-123",
            "fields": {
                "summary": "Test Issue Summary",
                "description": "Test Issue Description",
                "status": {
                    "name": "In Progress"
                }
            }
        }
        """.data(using: .utf8)!

        // Act
        let issueResponse = try JSONDecoder().decode(IssueResponse.self, from: json)

        // Assert
        XCTAssertEqual(issueResponse.id, "1001")
        XCTAssertEqual(issueResponse.key, "JIRA-123")
        XCTAssertEqual(issueResponse.fields.summary, "Test Issue Summary")
        XCTAssertEqual(issueResponse.fields.description, "Test Issue Description")
        XCTAssertEqual(issueResponse.fields.status.name, "In Progress")
    }

    func testDecodeIssueResponse_MissingOptionalFields() throws {
        // Arrange
        let json = """
        {
            "id": "1002",
            "key": "JIRA-124",
            "fields": {
                "summary": "Another Test Issue",
                "status": {
                    "name": "Open"
                }
            }
        }
        """.data(using: .utf8)!

        // Act
        let issueResponse = try JSONDecoder().decode(IssueResponse.self, from: json)

        // Assert
        XCTAssertEqual(issueResponse.id, "1002")
        XCTAssertEqual(issueResponse.key, "JIRA-124")
        XCTAssertEqual(issueResponse.fields.summary, "Another Test Issue")
        XCTAssertNil(issueResponse.fields.description) // Description is optional
        XCTAssertEqual(issueResponse.fields.status.name, "Open")
    }

    func testDecodeIssueResponse_InvalidJSON() {
        // Arrange
        let invalidJson = """
        {
            "id": "1003",
            "key": "JIRA-125"
        }
        """.data(using: .utf8)!

        // Act & Assert
        XCTAssertThrowsError(try JSONDecoder().decode(IssueResponse.self, from: invalidJson)) { error in
            XCTAssertTrue(error is DecodingError, "Expected DecodingError but got \(error)")
        }
    }
}
