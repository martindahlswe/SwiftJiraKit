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
    let token = "testBearerToken"

    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        networkManager = NetworkManager(baseURL: baseURL, token: token, urlSession: mockURLSession)
    }

    override func tearDown() {
        mockURLSession = nil
        networkManager = nil
        super.tearDown()
    }

    func testGetData_Success() async throws {
        let expectedData = "Test Data".data(using: .utf8)!
        mockURLSession.mockResponse = (expectedData, HTTPURLResponse(url: baseURL.appendingPathComponent("/test"), statusCode: 200, httpVersion: nil, headerFields: nil)!)

        let data = try await networkManager.getData(from: "/test")
        XCTAssertEqual(data, expectedData)
        XCTAssertEqual(mockURLSession.capturedRequest?.value(forHTTPHeaderField: "Authorization"), "Bearer \(token)")
        XCTAssertEqual(mockURLSession.capturedRequest?.httpMethod, "GET")
    }

    func testGetData_Failure_InvalidResponse() async {
        // Simulate a missing response
        mockURLSession.mockResponse = nil

        await XCTAssertAsyncThrowsError(try await self.networkManager.getData(from: "/test")) { error in
            guard let apiError = error as? APIError, case .networkError(let innerError) = apiError else {
                XCTFail("Expected APIError.networkError wrapping APIError.invalidResponse, but got \(error)")
                return
            }
            XCTAssert(innerError is APIError)
            XCTAssertEqual(innerError as? APIError, .invalidResponse)
        }
    }

    func testGetData_Failure_HTTPError() async {
        // Simulate an HTTP 404 error
        mockURLSession.mockResponse = (nil, HTTPURLResponse(url: baseURL.appendingPathComponent("/test"), statusCode: 404, httpVersion: nil, headerFields: nil)!)

        await XCTAssertAsyncThrowsError(try await self.networkManager.getData(from: "/test")) { error in
            guard let apiError = error as? APIError, case .networkError(let innerError) = apiError else {
                XCTFail("Expected APIError.networkError wrapping APIError.unknown(\"HTTP 404\"), but got \(error)")
                return
            }
            XCTAssert(innerError is APIError)
            XCTAssertEqual(innerError as? APIError, .unknown("HTTP 404"))
        }
    }
}
