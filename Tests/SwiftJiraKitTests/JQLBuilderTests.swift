//
//  JQLBuilderTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//


//
//  JQLBuilderTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class JQLBuilderTests: XCTestCase {
    var builder: JQLBuilder!

    override func setUp() {
        super.setUp()
        builder = JQLBuilder()
    }

    override func tearDown() {
        builder = nil
        super.tearDown()
    }

    func testAssignedTo() {
        // Act
        let query = builder.assignedTo("john.doe").build()

        // Assert
        XCTAssertEqual(query, "assignee = \"john.doe\"")
    }

    func testWithStatus() {
        // Act
        let query = builder.withStatus("Open").build()

        // Assert
        XCTAssertEqual(query, "status = \"Open\"")
    }

    func testWithIssueType() {
        // Act
        let query = builder.withIssueType("Bug").build()

        // Assert
        XCTAssertEqual(query, "issuetype = \"Bug\"")
    }

    func testCreatedOnOrAfter() {
        // Arrange
        let date = ISO8601DateFormatter().date(from: "2025-01-05T00:00:00Z")!

        // Act
        let query = builder.createdOnOrAfter(date).build()

        // Assert
        XCTAssertEqual(query, "created >= \"2025-01-05T00:00:00Z\"")
    }

    func testMultipleConditions() {
        // Act
        let query = builder
            .assignedTo("jane.doe")
            .withStatus("In Progress")
            .withIssueType("Task")
            .build()

        // Assert
        XCTAssertEqual(query, "assignee = \"jane.doe\" AND status = \"In Progress\" AND issuetype = \"Task\"")
    }

    func testReset() {
        // Arrange
        builder.assignedTo("jane.doe").withStatus("In Progress")

        // Act
        builder.reset()
        let query = builder.build()

        // Assert
        XCTAssertEqual(query, "")
    }

    func testPreview() {
        // Act
        let preview = builder.assignedTo("john.doe").preview()

        // Assert
        XCTAssertEqual(preview, "assignee = \"john.doe\"")
    }

    func testEmptyBuild() {
        // Act
        let query = builder.build()

        // Assert
        XCTAssertEqual(query, "")
    }
}
