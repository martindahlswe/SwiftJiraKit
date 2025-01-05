//
//  MockUtilities.swift
//  SwiftJiraKitTests
//

import Foundation
import XCTest
@testable import SwiftJiraKit

// Mock implementation of URLSessionProtocol
final class MockURLSession: URLSessionProtocol {
    var mockResponse: (Data?, HTTPURLResponse)?
    var mockError: Error?
    var capturedRequest: URLRequest?

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        capturedRequest = request
        if let error = mockError {
            throw error
        }
        guard mockResponse?.1 != nil else {
            throw APIError.invalidResponse
        }
        return (mockResponse?.0 ?? Data(), mockResponse!.1)
    }
}

// Mock implementation of NetworkManaging for JiraAPI tests
final class MockNetworkManager: NetworkManaging {
    var mockResponse: (Data?, HTTPURLResponse)?
    var mockError: Error?

    func getData(from endpoint: String) async throws -> Data {
        if let error = mockError {
            throw error
        }
        guard mockResponse?.1 != nil else {
            throw APIError.invalidResponse
        }
        return mockResponse?.0 ?? Data()
    }

    func postData(to endpoint: String, body: Data) async throws -> Data {
        throw APIError.unknown("POST request not implemented")
    }

    func deleteData(at endpoint: String) async throws {
        throw APIError.unknown("DELETE request not implemented")
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
