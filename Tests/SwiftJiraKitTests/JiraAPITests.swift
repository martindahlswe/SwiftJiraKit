//
//  JiraAPITests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class JiraAPITests: XCTestCase {
    private var jiraAPI: JiraAPI!
    private var mockNetworkManager: MockNetworkManager!
    private let baseURL = URL(string: "https://your-jira-instance.atlassian.net")!
    private let token = "testBearerToken"

    override func setUp() {
        super.setUp()
        // Inject MockNetworkManager into JiraAPI for testing
        mockNetworkManager = MockNetworkManager()
        jiraAPI = JiraAPI(baseURL: baseURL, token: token, networkManager: mockNetworkManager)
    }

    override func tearDown() {
        jiraAPI = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testValidateConnectivity() async throws {
        // Mock success response for "rest/api/2/myself"
        mockNetworkManager.mockResponse = (Data(), HTTPURLResponse(url: baseURL.appendingPathComponent("rest/api/2/myself"), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let result = try await jiraAPI.validateConnectivity()
        XCTAssertTrue(result)
    }

    func testGetAuthenticatedUserDetails() async throws {
        // Mock valid user data response
        let mockData = """
        {
            "name": "test_user",
            "emailAddress": "test@example.com"
        }
        """.data(using: .utf8)!
        mockNetworkManager.mockResponse = (mockData, HTTPURLResponse(url: baseURL.appendingPathComponent("rest/api/2/myself"), statusCode: 200, httpVersion: nil, headerFields: nil)!)
        
        let userData = try await jiraAPI.getAuthenticatedUserDetails()
        XCTAssertNotNil(userData)
        XCTAssertEqual(userData["name"] as? String, "test_user")
        XCTAssertEqual(userData["emailAddress"] as? String, "test@example.com")
    }
}
