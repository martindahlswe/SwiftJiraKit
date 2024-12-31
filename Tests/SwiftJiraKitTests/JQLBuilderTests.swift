//
//  JQLBuilderTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-31.
//


import XCTest
@testable import SwiftJiraKit

final class JQLBuilderTests: XCTestCase {
    func testJQLBuilder_singleCondition() {
        var builder = JQLBuilder()
        let jql = builder
            .addCondition(field: "status", comparisonOperator: "=", value: "Open")
            .build()
        XCTAssertEqual(jql, #"status = "Open""#)
    }

    func testJQLBuilder_multipleConditions() {
        var builder = JQLBuilder()
        let jql = builder
            .addCondition(field: "assignee", comparisonOperator: "=", value: "currentUser()")
            .addCondition(field: "status", comparisonOperator: "=", value: "Open")
            .build()
        XCTAssertEqual(jql, #"assignee = "currentUser()" AND status = "Open""#)
    }

    func testJQLBuilder_multipleValuesCondition() {
        var builder = JQLBuilder()
        let jql = builder
            .addCondition(field: "status", comparisonOperator: "IN", values: ["Open", "In Progress", "Reopened"])
            .build()
        XCTAssertEqual(jql, #"status IN ("Open", "In Progress", "Reopened")"#)
    }
}
