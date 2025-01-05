//
//  IssueServiceTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class IssueServiceTests: XCTestCase {
    var issueService: IssueService!
    var localMockNetworkManager: ILocalMockNetworkManager!

    override func setUp() {
        super.setUp()
        localMockNetworkManager = ILocalMockNetworkManager()
        issueService = IssueService(networkManager: localMockNetworkManager, serverName: "https://api.jira.com")
    }

    override func tearDown() {
        issueService = nil
        localMockNetworkManager = nil
        super.tearDown()
    }

    func testGetIssue_Success() async throws {
        // Arrange
        let mockIssueJSON = """
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
        localMockNetworkManager.mockResponse = mockIssueJSON

        // Act
        let issue = try await issueService.getIssue(issueKey: "JIRA-123")

        // Assert
        XCTAssertEqual(issue.id, "1001")
        XCTAssertEqual(issue.key, "JIRA-123")
        XCTAssertEqual(issue.fields.summary, "Test Issue Summary")
        XCTAssertEqual(issue.fields.description, "Test Issue Description")
        XCTAssertEqual(issue.fields.status.name, "In Progress")
    }

    func testGetIssue_DecodingError() async throws {
        // Arrange
        localMockNetworkManager.mockResponse = Data() // Invalid JSON data

        // Act & Assert
        do {
            _ = try await issueService.getIssue(issueKey: "JIRA-123")
            XCTFail("Expected decodingError, but no error was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testSearchIssues_Success() async throws {
        // Arrange
        let mockSearchJSON = """
        [
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
            },
            {
                "id": "1002",
                "key": "JIRA-124",
                "fields": {
                    "summary": "Another Test Issue",
                    "description": "Another Test Description",
                    "status": {
                        "name": "Open"
                    }
                }
            }
        ]
        """.data(using: .utf8)!
        localMockNetworkManager.mockResponse = mockSearchJSON

        // Act
        let issues = try await issueService.searchIssues(jql: "status = 'Open'")

        // Assert
        XCTAssertEqual(issues.count, 2)
        XCTAssertEqual(issues[0].id, "1001")
        XCTAssertEqual(issues[1].fields.summary, "Another Test Issue")
    }
}

// Local mock implementation of NetworkManaging
final class ILocalMockNetworkManager: NetworkManaging {
    var mockResponse: Data?
    var mockError: Error?

    func getData(from endpoint: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockResponse ?? Data()
    }

    func postData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for IssueService tests
    }

    func deleteData(at endpoint: String) async throws {
        throw APIError.invalidRequestBody // Not needed for IssueService tests
    }

    func putData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for IssueService tests
    }

    func patchData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for IssueService tests
    }
}
