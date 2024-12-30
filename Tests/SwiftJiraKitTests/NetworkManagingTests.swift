//
//  NetworkManagingTests.swift
//  SwiftJiraKit
//
//  Created by Martin Dahl on 2024-12-30.
//


import XCTest
@testable import SwiftJiraKit

final class NetworkManagingTests: XCTestCase {
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        mockNetworkManager = MockNetworkManager()
    }

    func testSuccessResponse() throws {
        let expectedData = try JSONEncoder().encode(["key": "value"])
        mockNetworkManager.mockResponse = .success(expectedData)

        mockNetworkManager.sendRequest(endpoint: "test", method: "GET", body: nil) { (result: Result<[String: String], Error>) in
            switch result {
            case .success(let response):
                XCTAssertEqual(response["key"], "value")
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
    }

    func testFailureResponse() {
        mockNetworkManager.mockResponse = .failure(APIError.invalidResponse)

        mockNetworkManager.sendRequest(endpoint: "test", method: "GET", body: nil) { (result: Result<[String: String], Error>) in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error as? APIError, APIError.invalidResponse)
            }
        }
    }
}
