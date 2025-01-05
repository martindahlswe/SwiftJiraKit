//
//  JiraAPITests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//


//
//  JiraAPITests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class JiraAPITests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!
    var jiraAPI: JiraAPI!

    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        jiraAPI = JiraAPI(networkManager: mockNetworkManager)
    }

    override func tearDown() {
        mockNetworkManager = nil
        jiraAPI = nil
        super.tearDown()
    }

    func testValidateConnectivity_Success() async throws {
        // Arrange: Simulate a successful response
        mockNetworkManager.mockData = Data()

        // Act
        let isConnected = try await jiraAPI.validateConnectivity()

        // Assert
        XCTAssertTrue(isConnected, "Expected connectivity validation to succeed")
    }

    func testValidateConnectivity_Failure() async {
        // Arrange: Simulate a network error
        mockNetworkManager.mockError = APIError.networkError(NSError(domain: "Test", code: 1))

        // Act & Assert
        do {
            _ = try await jiraAPI.validateConnectivity()
            XCTFail("Expected validateConnectivity to throw")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.networkError(NSError(domain: "Test", code: 1)))
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testGetAuthenticatedUserDetails_Success() async throws {
        // Arrange: Simulate a successful response with mock data
        let mockUserData = """
        {
            "name": "Test User",
            "emailAddress": "test@example.com",
            "displayName": "Test User"
        }
        """.data(using: .utf8)!
        mockNetworkManager.mockData = mockUserData

        // Act
        let data = try await jiraAPI.getAuthenticatedUserDetails()

        // Assert
        XCTAssertEqual(data, mockUserData, "Expected user details data to match mock data")
    }

    func testGetAuthenticatedUserDetails_Failure() async {
        // Arrange: Simulate a decoding error
        mockNetworkManager.mockError = APIError.decodingError

        // Act & Assert
        do {
            _ = try await jiraAPI.getAuthenticatedUserDetails()
            XCTFail("Expected getAuthenticatedUserDetails to throw")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// Mock implementation of NetworkManaging for testing purposes
final class MockNetworkManager: NetworkManaging {
    var mockData: Data?
    var mockError: Error?

    func getData(from endpoint: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }

    func postData(to endpoint: String, body: Data) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }

    func deleteData(at endpoint: String) async throws {
        if let error = mockError {
            throw error
        }
    }

    func putData(to endpoint: String, body: Data) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }

    func patchData(to endpoint: String, body: Data) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockData ?? Data()
    }
}
