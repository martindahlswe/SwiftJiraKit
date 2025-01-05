//
//  NetworkManagerTests.swift
//  SwiftJiraKitTests
//

import XCTest
@testable import SwiftJiraKit

final class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    var mockURLSession: MockURLSession!
    let baseURL = URL(string: "https://api.example.com")!

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(baseURL: baseURL, urlSession: mockURLSession)
    }

    override func tearDown() {
        mockURLSession = nil
        networkManager = nil
        super.tearDown()
    }

    func testGetData_Success() async throws {
        let expectedData = "Test Data".data(using: .utf8)!
        mockURLSession.mockResponse = (expectedData, HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: nil, headerFields: nil)!)
        let data = try await networkManager.getData(from: "/test")
        XCTAssertEqual(data, expectedData)
    }

    func testGetData_Failure_InvalidResponse() async {
        mockURLSession.mockResponse = nil

        await XCTAssertAsyncThrowsError(try await self.networkManager.getData(from: "/test")) { error in
            guard case let APIError.networkError(innerError) = error,
                  innerError as? APIError == APIError.invalidResponse else {
                XCTFail("Expected invalidResponse wrapped in networkError, but got \(error)")
                return
            }
        }
    }

    func testGetData_Failure_HTTPError() async {
        mockURLSession.mockResponse = (nil, HTTPURLResponse(url: baseURL, statusCode: 404, httpVersion: nil, headerFields: nil)!)

        await XCTAssertAsyncThrowsError(try await self.networkManager.getData(from: "/test")) { error in
            guard case let APIError.networkError(innerError) = error,
                  innerError as? APIError == APIError.unknown("HTTP 404") else {
                XCTFail("Expected HTTP 404 wrapped in networkError, but got \(error)")
                return
            }
        }
    }
}

// Custom helper for async error assertions
func XCTAssertAsyncThrowsError<T>(
    _ expression: @autoclosure @escaping () async throws -> T,
    _ message: @autoclosure @escaping () -> String = "",
    file: StaticString = #file,
    line: UInt = #line,
    _ errorHandler: ((Error) -> Void)? = nil
) async {
    do {
        _ = try await expression()
        XCTFail(message(), file: file, line: line)
    } catch {
        errorHandler?(error)
    }
}

// Mock implementation of URLSessionProtocol
final class MockURLSession: URLSessionProtocol {
    var mockResponse: (Data?, HTTPURLResponse)?
    var mockError: Error?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        if let error = mockError {
            throw error
        }
        guard let response = mockResponse?.1 else {
            throw APIError.invalidResponse
        }
        return (mockResponse?.0 ?? Data(), response)
    }
}
