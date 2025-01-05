//
//  NetworkManagingTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class NetworkManagingTests: XCTestCase {
    var mockManager: LocalMockNetworkManager!

    override func setUp() {
        super.setUp()
        mockManager = LocalMockNetworkManager()
    }

    override func tearDown() {
        mockManager = nil
        super.tearDown()
    }

    func testGetData_Success() async throws {
        // Arrange
        let expectedData = "Test GET Data".data(using: .utf8)!
        mockManager.mockResponse = expectedData

        // Act
        let data = try await mockManager.getData(from: "/test-get")

        // Assert
        XCTAssertEqual(data, expectedData, "GET data did not match the expected result")
    }

    func testPostData_Success() async throws {
        // Arrange
        let expectedData = "Test POST Response".data(using: .utf8)!
        let postBody = "Test POST Body".data(using: .utf8)!
        mockManager.mockResponse = expectedData

        // Act
        let data = try await mockManager.postData(to: "/test-post", body: postBody)

        // Assert
        XCTAssertEqual(data, expectedData, "POST response did not match the expected result")
    }

    func testDeleteData_Success() async throws {
        // Arrange
        mockManager.mockResponse = Data()

        // Act & Assert
        do {
            try await mockManager.deleteData(at: "/test-delete")
        } catch {
            XCTFail("Expected no error, but got: \(error)")
        }
    }

    func testPutData_DefaultImplementation() async throws {
        // Act & Assert
        do {
            _ = try await mockManager.putData(to: "/test-put", body: Data())
            XCTFail("Expected an error but none was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.invalidRequestBody, "PUT did not throw the expected default error")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testPatchData_DefaultImplementation() async throws {
        // Act & Assert
        do {
            _ = try await mockManager.patchData(to: "/test-patch", body: Data())
            XCTFail("Expected an error but none was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.invalidRequestBody, "PATCH did not throw the expected default error")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// Local mock implementation of NetworkManaging
final class LocalMockNetworkManager: NetworkManaging {
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
        if let error = mockError {
            throw error
        }
    }

    func putData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody
    }

    func patchData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody
    }
}
