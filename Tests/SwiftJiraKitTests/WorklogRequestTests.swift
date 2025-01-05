//
//  WorklogRequestTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//


//
//  WorklogRequestTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class WorklogRequestTests: XCTestCase {
    func testWorklogRequestInitialization_WithStrings() {
        // Arrange
        let timeSpent = "2h"
        let started = "2025-01-01T10:00:00Z"
        let comment = "Worked on feature X"
        let visibility = WorklogRequest.Visibility(type: "group", value: "jira-users")

        // Act
        let worklog = WorklogRequest(timeSpent: timeSpent, started: started, comment: comment, visibility: visibility)

        // Assert
        XCTAssertEqual(worklog.timeSpent, timeSpent)
        XCTAssertEqual(worklog.started, started)
        XCTAssertEqual(worklog.comment, comment)
        XCTAssertNotNil(worklog.visibility)
        XCTAssertEqual(worklog.visibility?.type, "group")
        XCTAssertEqual(worklog.visibility?.value, "jira-users")
    }

    func testWorklogRequestInitialization_WithDate() {
        // Arrange
        let timeSpent = "3h"
        let startedDate = ISO8601DateFormatter().date(from: "2025-01-01T12:00:00Z")!
        let comment = "Worked on feature Y"

        // Act
        let worklog = WorklogRequest(timeSpent: timeSpent, started: startedDate, comment: comment)

        // Assert
        XCTAssertEqual(worklog.timeSpent, timeSpent)
        XCTAssertEqual(worklog.started, "2025-01-01T12:00:00Z")
        XCTAssertEqual(worklog.comment, comment)
        XCTAssertNil(worklog.visibility)
    }

    func testWorklogRequestEncoding() throws {
        // Arrange
        let timeSpent = "1h 30m"
        let started = "2025-01-01T14:00:00Z"
        let comment = "Fixed a bug"
        let visibility = WorklogRequest.Visibility(type: "role", value: "developers")
        let worklog = WorklogRequest(timeSpent: timeSpent, started: started, comment: comment, visibility: visibility)

        // Act
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(worklog)
        let jsonString = String(data: data, encoding: .utf8)

        // Assert
        XCTAssertEqual(jsonString, """
        {"comment":"Fixed a bug","started":"2025-01-01T14:00:00Z","timeSpent":"1h 30m","visibility":{"type":"role","value":"developers"}}
        """)
    }

    func testWorklogRequestEncoding_WithNilVisibility() throws {
        // Arrange
        let timeSpent = "2h"
        let started = "2025-01-01T15:00:00Z"
        let comment = "Code review"
        let worklog = WorklogRequest(timeSpent: timeSpent, started: started, comment: comment)

        // Act
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let data = try encoder.encode(worklog)
        let jsonString = String(data: data, encoding: .utf8)

        // Assert
        XCTAssertEqual(jsonString, """
        {"comment":"Code review","started":"2025-01-01T15:00:00Z","timeSpent":"2h"}
        """)
    }
}
