//
//  DateFormatterExtensionsTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class DateFormatterExtensionsTests: XCTestCase {
    func testISO8601Formatter_ParsesValidDate() {
        // Arrange
        let dateString = "2025-01-05T10:00:00.000Z"
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let expectedDate = isoFormatter.date(from: dateString)

        // Act
        let parsedDate = DateFormatter.iso8601.date(from: dateString)

        // Assert
        XCTAssertEqual(parsedDate, expectedDate, "ISO8601 formatter did not parse the date correctly")
    }

    func testISO8601Formatter_FormatsDateCorrectly() {
        // Arrange
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = isoFormatter.date(from: "2025-01-05T10:00:00.000Z")
        XCTAssertNotNil(date, "Failed to parse date string with ISO8601DateFormatter")

        let expectedString = "2025-01-05T10:00:00.000Z"

        // Act
        let formattedString = DateFormatter.iso8601.string(from: date!)

        // Assert
        XCTAssertEqual(formattedString, expectedString, "ISO8601 formatter did not format the date correctly")
    }

    func testJiraDateFormatter_ParsesValidDate() {
        // Arrange
        let dateString = "2025-01-05"
        let expectedDate = DateFormatter.jiraDate.date(from: dateString)

        // Act
        let parsedDate = DateFormatter.jiraDate.date(from: dateString)

        // Assert
        XCTAssertEqual(parsedDate, expectedDate, "JiraDate formatter did not parse the date correctly")
    }

    func testJiraDateFormatter_FormatsDateCorrectly() {
        // Arrange
        let date = DateFormatter.jiraDate.date(from: "2025-01-05")!
        let expectedString = "2025-01-05"

        // Act
        let formattedString = DateFormatter.jiraDate.string(from: date)

        // Assert
        XCTAssertEqual(formattedString, expectedString, "JiraDate formatter did not format the date correctly")
    }

    func testISO8601Formatter_InvalidDate() {
        // Arrange
        let invalidDateString = "InvalidDate"

        // Act
        let parsedDate = DateFormatter.iso8601.date(from: invalidDateString)

        // Assert
        XCTAssertNil(parsedDate, "ISO8601 formatter should return nil for invalid dates")
    }

    func testJiraDateFormatter_InvalidDate() {
        // Arrange
        let invalidDateString = "InvalidDate"

        // Act
        let parsedDate = DateFormatter.jiraDate.date(from: invalidDateString)

        // Assert
        XCTAssertNil(parsedDate, "JiraDate formatter should return nil for invalid dates")
    }
}
