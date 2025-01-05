//
//  ConnectivityServiceTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class ConnectivityServiceTests: XCTestCase {
    var connectivityService: ConnectivityService!
    var localMockNetworkManager: CLocalMockNetworkManager!

    override func setUp() {
        super.setUp()
        localMockNetworkManager = CLocalMockNetworkManager()
        connectivityService = ConnectivityService(networkManager: localMockNetworkManager)
    }

    override func tearDown() {
        connectivityService = nil
        localMockNetworkManager = nil
        super.tearDown()
    }

    func testValidateConnectivity_Success() async throws {
        // Arrange
        let mockResponseData = """
        {
            "name": "Test User",
            "emailAddress": "test@example.com",
            "displayName": "Test User"
        }
        """.data(using: .utf8)!
        localMockNetworkManager.mockResponse = mockResponseData

        // Act
        let isConnected = try await connectivityService.validateConnectivity()

        // Assert
        XCTAssertTrue(isConnected, "Expected connectivity to be validated successfully")
    }

    func testValidateConnectivity_DecodingError() async throws {
        // Arrange
        localMockNetworkManager.mockResponse = Data() // Invalid JSON data

        // Act & Assert
        do {
            _ = try await connectivityService.validateConnectivity()
            XCTFail("Expected decodingError, but no error was thrown")
        } catch let error as APIError {
            XCTAssertEqual(error, APIError.decodingError, "Expected decodingError but got \(error)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }

    func testValidateConnectivity_NetworkError() async throws {
        // Arrange
        localMockNetworkManager.mockError = APIError.networkError(NSError(domain: "TestDomain", code: -1009))

        // Act & Assert
        do {
            _ = try await connectivityService.validateConnectivity()
            XCTFail("Expected networkError, but no error was thrown")
        } catch let error as APIError {
            guard case let .networkError(innerError) = error else {
                XCTFail("Expected networkError but got \(error)")
                return
            }
            XCTAssertEqual((innerError as NSError).domain, "TestDomain", "Expected domain 'TestDomain' but got \((innerError as NSError).domain)")
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }
    }
}

// Local mock implementation of NetworkManaging
final class CLocalMockNetworkManager: NetworkManaging {
    var mockResponse: Data?
    var mockError: Error?

    func getData(from endpoint: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        return mockResponse ?? Data()
    }

    func postData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for ConnectivityService tests
    }

    func deleteData(at endpoint: String) async throws {
        throw APIError.invalidRequestBody // Not needed for ConnectivityService tests
    }

    func putData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for ConnectivityService tests
    }

    func patchData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.invalidRequestBody // Not needed for ConnectivityService tests
    }
}
