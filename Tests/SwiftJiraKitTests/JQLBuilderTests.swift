import XCTest
@testable import SwiftJiraKit

final class JQLBuilderTests: XCTestCase {
    func testAssignedTo() {
        let builder = JQLBuilder()
        let query = builder.assignedTo("johndoe").build()
        XCTAssertEqual(query, "assignee = \"johndoe\"")
    }

    func testWithStatus() {
        let builder = JQLBuilder()
        let query = builder.withStatus("In Progress").build()
        XCTAssertEqual(query, "status = \"In Progress\"")
    }

    func testWithIssueType() {
        let builder = JQLBuilder()
        let query = builder.withIssueType("Bug").build()
        XCTAssertEqual(query, "issuetype = \"Bug\"")
    }

    func testCreatedOnOrAfter() {
        let builder = JQLBuilder()
        let date = ISO8601DateFormatter().date(from: "2023-01-01T00:00:00Z")!
        let query = builder.createdOnOrAfter(date).build()
        XCTAssertEqual(query, "created >= \"2023-01-01T00:00:00Z\"")
    }

    func testReset() {
        let builder = JQLBuilder()
        builder.assignedTo("johndoe").withStatus("In Progress")
        builder.reset()
        XCTAssertEqual(builder.build(), "")
    }

    func testBuild() {
        let builder = JQLBuilder()
        let query = builder.assignedTo("johndoe").withStatus("In Progress").build()
        XCTAssertEqual(query, "assignee = \"johndoe\" AND status = \"In Progress\"")
    }
}
