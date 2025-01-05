//
//  WorklogServiceTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class WorklogServiceTests: XCTestCase {
    var worklogService: WorklogService!
    var mockNetworkManager: WMockNetworkManager!

    override func setUp() {
        super.setUp()
        mockNetworkManager = WMockNetworkManager()
        worklogService = WorklogService(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        worklogService = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testGetWorklogs_Success() async throws {
        // Arrange
        let mockWorklogJSON = """
        [
            {
                "id": "1001",
                "issueId": "JIRA-123",
                "author": {
                    "accountId": "abc123",
                    "displayName": "John Doe",
                    "active": true
                },
                "comment": "Worked on feature X",
                "started": "2025-01-01T10:00:00Z",
                "timeSpent": "2h",
                "timeSpentSeconds": 7200
            }
        ]
        """.data(using: .utf8)!
        mockNetworkManager.mockResponse = mockWorklogJSON

        // Act
        let worklogs = try await worklogService.getWorklogs(for: "JIRA-123")

        // Assert
        XCTAssertEqual(worklogs.count, 1)
        XCTAssertEqual(worklogs[0].id, "1001")
        XCTAssertEqual(worklogs[0].author?.displayName, "John Doe")
        XCTAssertEqual(worklogs[0].comment, "Worked on feature X")
    }

    func testGetWorklogs_DecodingError() async {
        // Arrange
        mockNetworkManager.mockResponse = Data() // Invalid JSON data

        // Act & Assert
        do {
            _ = try await worklogService.getWorklogs(for: "JIRA-123")
            XCTFail("Expected decodingError, but no error was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError, "Expected decodingError but got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testAddWorklog_Success() async throws {
        // Arrange
        let mockWorklogResponseJSON = """
        {
            "id": "2001",
            "issueId": "JIRA-123",
            "author": {
                "accountId": "abc123",
                "displayName": "John Doe",
                "active": true
            },
            "comment": "Worked on feature Y",
            "started": "2025-01-01T12:00:00Z",
            "timeSpent": "3h",
            "timeSpentSeconds": 10800
        }
        """.data(using: .utf8)!
        let worklogRequest = WorklogRequest(timeSpent: "3h", started: "2025-01-01T12:00:00Z", comment: "Worked on feature Y")
        mockNetworkManager.mockResponse = mockWorklogResponseJSON

        // Act
        let createdWorklog = try await worklogService.addWorklog(to: "JIRA-123", worklog: worklogRequest)

        // Assert
        XCTAssertEqual(createdWorklog.id, "2001")
        XCTAssertEqual(createdWorklog.author?.displayName, "John Doe")
        XCTAssertEqual(createdWorklog.comment, "Worked on feature Y")
    }

    func testAddWorklog_DecodingError() async {
        // Arrange
        let worklogRequest = WorklogRequest(timeSpent: "3h", started: "2025-01-01T12:00:00Z", comment: "Worked on feature Y")
        mockNetworkManager.mockResponse = Data() // Invalid JSON data

        // Act & Assert
        do {
            _ = try await worklogService.addWorklog(to: "JIRA-123", worklog: worklogRequest)
            XCTFail("Expected decodingError, but no error was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError, "Expected decodingError but got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// Local mock implementation of NetworkManaging for WorklogService
final class WMockNetworkManager: NetworkManaging {
    var mockResponse: Data?
    var mockError: Error?

    func getData(from endpoint: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockResponse ?? Data()
    }

    func postData(to endpoint: String, body: Data) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockResponse ?? Data()
    }

    func deleteData(at endpoint: String) async throws {
        throw APIError.invalidRequestBody // Not used in WorklogService
    }

    func putData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not used in WorklogService
    }

    func patchData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not used in WorklogService
    }
}
