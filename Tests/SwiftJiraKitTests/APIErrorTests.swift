//
//  APIErrorTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2025-01-05.
//

import XCTest
@testable import SwiftJiraKit

final class APIErrorTests: XCTestCase {
    func testEquality() {
        // Test simple cases
        XCTAssertEqual(APIError.invalidResponse, APIError.invalidResponse)
        XCTAssertEqual(APIError.decodingError, APIError.decodingError)
        XCTAssertEqual(APIError.invalidRequestBody, APIError.invalidRequestBody)
        XCTAssertEqual(APIError.unauthorized, APIError.unauthorized)
        XCTAssertEqual(APIError.notFound, APIError.notFound)

        // Test network errors
        let networkError1 = APIError.networkError(NSError(domain: "Test", code: 1))
        let networkError2 = APIError.networkError(NSError(domain: "Test", code: 1))
        let networkError3 = APIError.networkError(NSError(domain: "Test", code: 2))
        XCTAssertEqual(networkError1, networkError2)
        XCTAssertNotEqual(networkError1, networkError3)

        // Test unknown errors
        XCTAssertEqual(APIError.unknown("Test"), APIError.unknown("Test"))
        XCTAssertNotEqual(APIError.unknown("Test"), APIError.unknown("Different"))
    }

    func testErrorDescriptions() {
        // Test specific error descriptions
        XCTAssertEqual(APIError.invalidResponse.errorDescription, "The response from the server was invalid.")
        XCTAssertEqual(APIError.decodingError.errorDescription, "Failed to decode the response from the server.")
        XCTAssertEqual(APIError.invalidRequestBody.errorDescription, "The request body is invalid.")
        XCTAssertEqual(APIError.unauthorized.errorDescription, "The request is unauthorized. Please check your credentials.")
        XCTAssertEqual(APIError.notFound.errorDescription, "The requested resource was not found.")

        // Test unknown error description
        XCTAssertEqual(APIError.unknown("An error occurred").errorDescription, "An unknown error occurred: An error occurred")

        // Test network error description
        let networkError = APIError.networkError(NSError(domain: "TestDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network failed"]))
        XCTAssertEqual(networkError.errorDescription, "A network error occurred: Network failed")
    }

    func testDebugDescriptions() {
        // Test debug description for network error
        let networkError = APIError.networkError(
            NSError(domain: "TestDomain", code: 404, userInfo: [NSLocalizedDescriptionKey: "Network failed"])
        )
        XCTAssertTrue(
            networkError.debugDescription.contains("NetworkError(debug): Error Domain=TestDomain Code=404 \"Network failed\""),
            "Debug description did not match expected format"
        )

        // Test debug description for other errors
        XCTAssertEqual(APIError.invalidResponse.debugDescription, "The response from the server was invalid.")
        XCTAssertEqual(APIError.decodingError.debugDescription, "Failed to decode the response from the server.")
    }

    func testEdgeCases() {
        // Test unknown with empty string
        XCTAssertEqual(APIError.unknown("").errorDescription, "An unknown error occurred: ")

        // Test network error with no description
        let emptyNetworkError = APIError.networkError(NSError(domain: "TestDomain", code: 0))
        XCTAssertEqual(emptyNetworkError.errorDescription, "A network error occurred: The operation couldn’t be completed. (TestDomain error 0.)")
    }
}
